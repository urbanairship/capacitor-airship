import { Capacitor } from '@capacitor/core';

import type { AirshipPluginWrapper } from './AirshipPlugin';

/**
 * Embedded view options.
 */
export interface EmbeddedViewOptions {
  /**
   * The embedded ID.
   */
  embeddedId: string;

  /**
   * The placeholder element. The native embedded view is sized and positioned
   * to match this element's bounding rect and is updated when the element
   * moves or resizes.
   */
  element: HTMLElement;

  /**
   * Optional element whose bounds clip the native view. Because the native
   * view renders above the web view, content outside a scroll container (such
   * as a header above an Ionic `ion-content`) would otherwise be covered as
   * the placeholder scrolls past it. Set this to the scroll container so the
   * native view is clipped to its bounds and appears to scroll underneath the
   * surrounding content. Defaults to the full web view (no clipping).
   */
  clipElement?: HTMLElement;
}

interface Frame {
  x: number;
  y: number;
  width: number;
  height: number;
}

let nextViewId = 0;

/**
 * Displays embedded Scene content inline by overlaying a native view on top of
 * a placeholder element.
 *
 * The native view tracks the placeholder element's bounding rect using a
 * ResizeObserver and document scroll/resize listeners. Because the native view
 * renders above the web view, web content is not able to display on top of it.
 * Use `hide` before displaying any web content that needs to cover the view,
 * and `show` to restore it. To keep surrounding content (such as a scrolling
 * header) above the view, provide a `clipElement` in the options.
 *
 * The placeholder element defines the size of the embedded view. Auto-sizing
 * to the Scene content is not supported.
 *
 * Use `Airship.inApp.addEmbeddedReadyListener` to know when content is
 * available for the embedded ID.
 */
export class AirshipEmbeddedView {
  private readonly viewId: string;
  private resizeObserver: ResizeObserver | null = null;
  private updateScheduled = false;
  private lastFrame: Frame | null = null;
  private lastClip: Frame | null = null;
  private destroyed = false;

  private readonly onLayoutChanged = () => this.scheduleFrameUpdate();

  private constructor(
    private readonly plugin: AirshipPluginWrapper,
    private readonly element: HTMLElement,
    private readonly clipElement?: HTMLElement,
  ) {
    this.viewId = `embedded-view-${nextViewId++}`;
  }

  /**
   * Creates an embedded view. Not supported on web.
   * @param plugin The plugin wrapper.
   * @param options The embedded view options.
   * @returns A promise with the embedded view.
   * @ignore
   */
  public static async create(plugin: AirshipPluginWrapper, options: EmbeddedViewOptions): Promise<AirshipEmbeddedView> {
    if (Capacitor.getPlatform() === 'web') {
      throw new Error('AirshipEmbeddedView is not supported on web');
    }

    const view = new AirshipEmbeddedView(plugin, options.element, options.clipElement);
    const frame = view.currentFrame();
    const clip = view.currentClip();
    await plugin.perform('embeddedView#create', {
      viewId: view.viewId,
      embeddedId: options.embeddedId,
      frame,
      clip,
    });

    view.lastFrame = frame;
    view.lastClip = clip;
    view.startTracking();
    return view;
  }

  /**
   * Shows the view if hidden.
   * @returns A promise.
   */
  public show(): Promise<void> {
    return this.plugin.perform('embeddedView#setVisible', {
      viewId: this.viewId,
      visible: true,
    });
  }

  /**
   * Hides the view without destroying it.
   * @returns A promise.
   */
  public hide(): Promise<void> {
    return this.plugin.perform('embeddedView#setVisible', {
      viewId: this.viewId,
      visible: false,
    });
  }

  /**
   * Notifies the view that the placeholder element may have moved. The
   * built-in scroll listener cannot observe scrolling inside shadow roots
   * (e.g. Ionic's `ion-content`), so call this from framework-specific scroll
   * events when the placeholder is inside one. Updates are throttled to one
   * per animation frame.
   */
  public notifyLayoutChanged(): void {
    this.scheduleFrameUpdate();
  }

  /**
   * Removes the native view and stops tracking the placeholder element.
   * @returns A promise.
   */
  public destroy(): Promise<void> {
    this.destroyed = true;
    this.resizeObserver?.disconnect();
    this.resizeObserver = null;
    document.removeEventListener('scroll', this.onLayoutChanged, true);
    window.removeEventListener('resize', this.onLayoutChanged);
    return this.plugin.perform('embeddedView#dispose', {
      viewId: this.viewId,
    });
  }

  private startTracking(): void {
    this.resizeObserver = new ResizeObserver(this.onLayoutChanged);
    this.resizeObserver.observe(this.element);

    // Scroll events do not bubble but are observable in the capture phase,
    // which covers scrolling in any ancestor scroll container.
    document.addEventListener('scroll', this.onLayoutChanged, true);
    window.addEventListener('resize', this.onLayoutChanged);
  }

  private currentFrame(): Frame {
    return rectToFrame(this.element.getBoundingClientRect());
  }

  private currentClip(): Frame {
    if (this.clipElement) {
      return rectToFrame(this.clipElement.getBoundingClientRect());
    }
    return { x: 0, y: 0, width: window.innerWidth, height: window.innerHeight };
  }

  private scheduleFrameUpdate(): void {
    if (this.updateScheduled || this.destroyed) {
      return;
    }
    this.updateScheduled = true;

    requestAnimationFrame(() => {
      this.updateScheduled = false;
      if (this.destroyed) {
        return;
      }

      const frame = this.currentFrame();
      const clip = this.currentClip();
      if (framesEqual(this.lastFrame, frame) && framesEqual(this.lastClip, clip)) {
        return;
      }

      this.lastFrame = frame;
      this.lastClip = clip;
      this.plugin.perform('embeddedView#updateFrame', {
        viewId: this.viewId,
        frame,
        clip,
      });
    });
  }
}

function rectToFrame(rect: DOMRect): Frame {
  return {
    x: rect.left,
    y: rect.top,
    width: rect.width,
    height: rect.height,
  };
}

function framesEqual(a: Frame | null, b: Frame): boolean {
  return a !== null && a.x === b.x && a.y === b.y && a.width === b.width && a.height === b.height;
}
