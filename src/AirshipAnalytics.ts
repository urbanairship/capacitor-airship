import type { AirshipPluginWrapper } from './AirshipPlugin';
import type { CustomEvent } from './types';

/**
 * Airship analytics.
 */
export class AirshipAnalytics {
  constructor(private readonly plugin: AirshipPluginWrapper) {}

  /**
   * Associates an identifier.
   *
   * @param key The key.
   * @param identifier The identifier. `null` to remove.
   * @returns A promise.
   */
  public associateIdentifier(key: string, identifier?: string): Promise<void> {
    return this.plugin.perform('analytics#associateIdentifier', [
      key,
      identifier,
    ]);
  }

  /**
   * Tracks a screen.
   * @param screen The screen. `null` to stop tracking.
   * @returns A promise.
   */
  public trackScreen(screen?: string): Promise<void> {
    return this.plugin.perform('analytics#trackScreen', screen);
  }

  /**
   * Adds a custom event.
   * @param event The custom event.
   * @return A promise that returns null if resolved, or an Error if the
   * custom event is rejected.
   */
  public addCustomEvent(event: CustomEvent): Promise<void> {
    return this.plugin.perform('analytics#addCustomEvent', event);
  }


  /**
   * Gets the Airship session ID. The session ID is a UUID that updates on foreground and background.
   * @returns A promise.
   */
  public getSessionId(): Promise<string> {
    return this.plugin.perform('analytics#getSessionId');
  }
}
