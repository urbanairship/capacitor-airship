import { AirshipPluginWrapper } from './plugin';

/**
 * Airship InApp Experiences.
 */
export class AirshipInApp {
  constructor(private readonly plugin: AirshipPluginWrapper) {}

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
