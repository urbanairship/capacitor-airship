import type { PluginListenerHandle } from '@capacitor/core';

import { AirshipActions } from './AirshipActions';
import { AirshipAnalytics } from './AirshipAnalytics';
import { AirshipChannel } from './AirshipChannel';
import { AirshipContact } from './AirshipContact';
import { AirshipFeatureFlagManager } from './AirshipFeatureFlagManager';
import { AirshipInApp } from './AirshipInApp';
import { AirshipLocale } from './AirshipLocale';
import { AirshipMessageCenter } from './AirshipMessageCenter';
import { AirshipPreferenceCenter } from './AirshipPreferenceCenter';
import { AirshipPrivacyManager } from './AirshipPrivacyManager';
import { AirshipPush } from './AirshipPush';
import { EventType } from './EventType';
import type { AirshipPluginWrapper } from './AirshipPlugin';
import type { AirshipConfig , DeepLinkEvent } from './types';
import { AirshipLiveActivityManager } from './AirshipLiveActivityManager';
import { AirshipLiveUpdateManager } from './AirshipLiveUpdateManager';

/**
 * Airship
 */
export class AirshipRoot {
  public readonly actions: AirshipActions;
  public readonly analytics: AirshipAnalytics;
  public readonly channel: AirshipChannel;
  public readonly contact: AirshipContact;
  public readonly inApp: AirshipInApp;
  public readonly locale: AirshipLocale;
  public readonly messageCenter: AirshipMessageCenter;
  public readonly preferenceCenter: AirshipPreferenceCenter;
  public readonly privacyManager: AirshipPrivacyManager;
  public readonly push: AirshipPush;
  public readonly featureFlagManager: AirshipFeatureFlagManager;

    /**
   * iOS only accessors
   */
    public readonly iOS: AirshipRootIOS;

    /**
     * iOS only accessors
     */
    public readonly android: AirshipRootAndroid;

  constructor(private readonly plugin: AirshipPluginWrapper) {
    this.actions = new AirshipActions(plugin);
    this.analytics = new AirshipAnalytics(plugin);
    this.channel = new AirshipChannel(plugin);
    this.contact = new AirshipContact(plugin);
    this.inApp = new AirshipInApp(plugin);
    this.locale = new AirshipLocale(plugin);
    this.messageCenter = new AirshipMessageCenter(plugin);
    this.preferenceCenter = new AirshipPreferenceCenter(plugin);
    this.privacyManager = new AirshipPrivacyManager(plugin);
    this.push = new AirshipPush(plugin);
    this.featureFlagManager = new AirshipFeatureFlagManager(plugin);
    this.iOS = new AirshipRootIOS(plugin);
    this.android = new AirshipRootAndroid(plugin);
  }

  /**
   * Calls takeOff. If Airship is already configured for
   * the app session, the new config will be applied on the next
   * app init.
   * @param config The config.
   * @returns A promise with the result. `true` if airship is ready.
   */
  public takeOff(config: AirshipConfig): Promise<boolean> {
    return this.plugin.perform('takeOff', config);
  }

  /**
   * Checks if Airship is ready.
   * @returns A promise with the result.
   */
  public isFlying(): Promise<boolean> {
    return this.plugin.perform('isFlying');
  }

  /**
   * Adds a deep link listener.
   */
  public onDeepLink(listener: (event: DeepLinkEvent) => void): Promise<PluginListenerHandle> {
    return this.plugin.addListener(EventType.DeepLink, listener)
  }
}


export class AirshipRootIOS {
  public readonly liveActivityManager: AirshipLiveActivityManager;
  
  constructor(plugin: AirshipPluginWrapper) {
    this.liveActivityManager = new AirshipLiveActivityManager(plugin);
  }
}

export class AirshipRootAndroid {
  public readonly liveUpdateManager: AirshipLiveUpdateManager;
  
  constructor(plugin: AirshipPluginWrapper) {
    this.liveUpdateManager = new AirshipLiveUpdateManager(plugin);
  }
}