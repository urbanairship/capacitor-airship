import { AirshipEmbeddedView } from './AirshipEmbeddedView';
import type { EmbeddedViewOptions } from './AirshipEmbeddedView';
import type { AirshipPluginWrapper } from './AirshipPlugin';
import { EventType } from './EventType';
import type { EmbeddedInfo } from './types';

/**
 * A listener subscription.
 */
export class Subscription {
  constructor(private readonly onRemove: () => void) {}

  /**
   * Removes the listener.
   */
  public remove(): void {
    this.onRemove();
  }
}

/**
 * Airship InApp Experiences.
 */
export class AirshipInApp {
  private pendingEmbedded: Map<string, EmbeddedInfo[]> = new Map();
  private pendingEmbeddedListeners: Map<string, ((pending: EmbeddedInfo[]) => void)[]> = new Map();
  private isWatchingEmbedded = false;

  constructor(private readonly plugin: AirshipPluginWrapper) {}

  /**
   * Adds a listener to listen for when an embedded ID is ready to display or not.
   *
   * The listener will be called immediately with the current value, then again
   * whenever the value changes.
   * @param embeddedId The embedded ID to check.
   * @param listener  The listener.
   * @returns A subscription that can be used to cancel the listener.
   */
  public addEmbeddedReadyListener(embeddedId: string, listener: (isReady: boolean) => void): Subscription {
    this.watchEmbedded();

    let currentValue = this.isEmbeddedReady(embeddedId);
    listener(currentValue);

    const wrappedListener = (pending: EmbeddedInfo[]) => {
      const nextValue = pending.length > 0;
      if (currentValue !== nextValue) {
        listener(nextValue);
      }
      currentValue = nextValue;
    };

    const listeners = this.pendingEmbeddedListeners.get(embeddedId) ?? [];
    listeners.push(wrappedListener);
    this.pendingEmbeddedListeners.set(embeddedId, listeners);

    return new Subscription(() => {
      this.pendingEmbeddedListeners.set(
        embeddedId,
        this.pendingEmbeddedListeners.get(embeddedId)?.filter((obj) => obj !== wrappedListener) ?? [],
      );
    });
  }

  /**
   * Checks if an embedded message is ready for the given ID.
   * @param embeddedId The embedded ID to check.
   * @returns `true` if one is ready, otherwise `false`.
   */
  public isEmbeddedReady(embeddedId: string): boolean {
    this.watchEmbedded();
    return (this.pendingEmbedded.get(embeddedId)?.length ?? 0) > 0;
  }

  private watchEmbedded(): void {
    if (this.isWatchingEmbedded) {
      return;
    }
    this.isWatchingEmbedded = true;

    this.plugin.addListener(EventType.PendingEmbeddedUpdated, (event) => {
      this.pendingEmbedded = event.pending.reduce((map, entry) => {
        const list = map.get(entry.embeddedId);
        if (list) {
          list.push(entry);
        } else {
          map.set(entry.embeddedId, [entry]);
        }
        return map;
      }, new Map<string, EmbeddedInfo[]>());

      this.pendingEmbeddedListeners.forEach((listeners, embeddedId) => {
        const pending = this.pendingEmbedded.get(embeddedId) ?? [];
        listeners.forEach((listener) => {
          listener(pending);
        });
      });
    });

    this.plugin.perform('inApp#resendPendingEmbeddedEvent');
  }

  /**
   * Creates an embedded view that displays embedded Scene content inline by
   * overlaying a native view on top of a placeholder element. Not supported
   * on web.
   * @param options The embedded view options.
   * @returns A promise with the embedded view.
   */
  public createEmbeddedView(options: EmbeddedViewOptions): Promise<AirshipEmbeddedView> {
    return AirshipEmbeddedView.create(this.plugin, options);
  }

  /**
   * Pauses messages.
   * @param paused `true` to pause, `false` to resume.
   * @returns A promise.
   */
  public setPaused(paused: boolean): Promise<void> {
    return this.plugin.perform('inApp#setPaused', paused);
  }

  /**
   * Checks if messages are paused.
   * @returns A promise with the result.
   */
  public isPaused(): Promise<boolean> {
    return this.plugin.perform('inApp#isPaused');
  }

  /**
   * Sets the display interval for messages.
   * @param milliseconds Display interval
   * @returns A promise.
   */
  public setDisplayInterval(milliseconds: number): Promise<void> {
    return this.plugin.perform('inApp#setDisplayInterval', milliseconds);
  }

  /**
   * Gets the display interval.
   * @returns A promise with the result.
   */
  public getDisplayInterval(): Promise<number> {
    return this.plugin.perform('inApp#getDisplayInterval');
  }
}
