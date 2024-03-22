import type { PluginListenerHandle } from '@capacitor/core';

import { EventType } from './EventType';
import type { AirshipPluginWrapper } from './AirshipPlugin';
import type { DisplayPreferenceCenterEvent, PreferenceCenter } from './types';
/**
 * Airship Preference Center.
 */
export class AirshipPreferenceCenter {
  constructor(private readonly plugin: AirshipPluginWrapper) {}

  /**
   * Requests to display a preference center.
   *
   * Will either emit an event to display the
   * Preference Center if auto launch is disabled,
   * or display the OOTB UI.
   * @param preferenceCenterId The preference center Id.
   * @returns A promise.
   */
  public display(preferenceCenterId: string): Promise<void> {
    return this.plugin.perform('preferenceCenter#display', preferenceCenterId);
  }

  /**
   * Gets the preference center config.
   * @param preferenceCenterId The preference center Id.
   * @returns A promise with the result.
   */
  public getConfig(preferenceCenterId: string): Promise<PreferenceCenter> {
    return this.plugin.perform(
      'preferenceCenter#getConfig',
      preferenceCenterId,
    );
  }

  /**
   * Enables or disables showing the OOTB UI when requested to display by either
   * `display` or by a notification with some other action.
   * @param preferenceCenterId The preference center Id.
   * @param autoLaunch true to show OOTB UI, false to emit events.
   * @returns A promise with the result.
   */
  public setAutoLaunchDefaultPreferenceCenter(
    preferenceCenterId: string,
    autoLaunch: boolean,
  ): Promise<void> {
    return this.plugin.perform('preferenceCenter#getConfig', [
      preferenceCenterId,
      autoLaunch,
    ]);
  }

  /**
   * Adds a display message center listener.
   */
  public onDisplay(
    listener: (event: DisplayPreferenceCenterEvent) => void,
  ): Promise<PluginListenerHandle> {
    return this.plugin.addListener(EventType.DisplayPreferenceCenter, listener);
  }
}
