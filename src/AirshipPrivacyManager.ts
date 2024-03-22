import type { AirshipPluginWrapper } from './AirshipPlugin';
import type { Feature } from './types';

/**
 * Airship Privacy Manager.
 */
export class AirshipPrivacyManager {
  constructor(private readonly plugin: AirshipPluginWrapper) {}

  /**
   * Sets the current set of enabled features.
   * @param features The features to set.
   * @returns A promise.
   */
  public setEnabledFeatures(features: Feature[]): Promise<void> {
    return this.plugin.perform('privacyManager#setEnabledFeatures', features);
  }

  /**
   * Gets the current enabled features.
   * @returns A promise with the result.
   */
  public getEnabledFeatures(): Promise<Feature[]> {
    return this.plugin.perform('privacyManager#getEnabledFeatures');
  }

  /**
   * Enables additional features.
   * @param features The features to enable.
   * @returns A promise.
   */
  public enableFeatures(features: Feature[]): Promise<void> {
    return this.plugin.perform('privacyManager#enableFeatures', features);
  }

  /**
   * Disable features.
   * @param features The features to disable.
   * @returns A promise.
   */
  public disableFeatures(features: Feature[]): Promise<void> {
    return this.plugin.perform('privacyManager#disableFeatures', features);
  }

  /**
   * Checks if the features are enabled or not.
   * @param features The features to check.
   * @returns A promise with the result.
   */
  public isFeaturesEnabled(features: Feature[]): Promise<void> {
    return this.plugin.perform('privacyManager#isFeaturesEnabled', features);
  }
}
