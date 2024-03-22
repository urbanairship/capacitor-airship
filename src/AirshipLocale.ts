import type { AirshipPluginWrapper } from './AirshipPlugin';

/**
 * Manages locale used by Airship messaging.
 */
export class AirshipLocale {
  constructor(private readonly plugin: AirshipPluginWrapper) {}

  /**
   * Sets the locale override.
   * @param localeIdentifier The locale identifier.
   * @returns A promise.
   */
  public setLocaleOverride(localeIdentifier: string): Promise<void> {
    return this.plugin.perform('locale#setLocaleOverride', localeIdentifier);
  }

  /**
   * Clears the locale override.
   * @returns A promise.
   */
  public clearLocaleOverride(): Promise<void> {
    return this.plugin.perform('locale#clearLocaleOverride');
  }

  /**
   * Gets the current locale.
   * @returns A promise with the result.
   */
  public getLocale(): Promise<string> {
    return this.plugin.perform('locale#getLocale');
  }
}
