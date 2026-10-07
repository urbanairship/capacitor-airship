import type { AirshipPluginWrapper } from './AirshipPlugin';
import type { FeatureFlag, FeatureFlagStatus } from './types';

/**
 * Airship feature flag manager.
 */
export class AirshipFeatureFlagManager {
  constructor(private readonly plugin: AirshipPluginWrapper) {}

 /**
   * Retrieve a given flag's status and associated data by its name.
   * @param {string} flagName The flag name
   * @return {Promise<FeatureFlag>} A promise resolving to the feature flag
   *   requested.
   * @throws {Error} when failed to fetch
   */
  public flag(
    flagName: string
  ): Promise<FeatureFlag> {
    return this.plugin.perform('featureFlagManager#flag', flagName);
  }

 /**
   * Tracks a feature flag interaction event.
   * @param {FeatureFlag} flag The flag
   * @return {Promise<Void>} A promise with an empty result.
   * @throws {Error} when failed to fetch
   */
  public trackInteraction(flag: FeatureFlag): Promise<void> {
    return this.plugin.perform('featureFlagManager#trackInteraction', flag);
  }

  /**
   * The freshness of the feature flag data used to resolve flags.
   * @return {Promise<FeatureFlagStatus>} A promise resolving to the status.
   */
  public status(): Promise<FeatureFlagStatus> {
    return this.plugin.perform('featureFlagManager#status');
  }

  /**
   * Suspends until the feature flag data is refreshed, or the given time elapses.
   * @param {number} [maxTimeMs] The max time to wait, in milliseconds. If not
   *   provided, waits until the data is refreshed with no timeout.
   * @return {Promise<void>} A promise with an empty result.
   */
  public waitRefresh(maxTimeMs?: number): Promise<void> {
    return this.plugin.perform('featureFlagManager#waitRefresh', maxTimeMs);
  }
}
