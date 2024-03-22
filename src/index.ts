
import { registerPlugin } from '@capacitor/core';

import { AirshipRoot } from './AirshipRoot';
import type { AirshipPlugin } from './AirshipPlugin';
import { AirshipPluginWrapper } from './AirshipPlugin';

export { AirshipRoot } from './AirshipRoot';
export { AirshipActions } from './AirshipActions';
export { AirshipAnalytics } from './AirshipAnalytics';
export { AirshipChannel } from './AirshipChannel';
export { AirshipContact } from './AirshipContact';
export { AirshipInApp } from './AirshipInApp';
export { AirshipLocale } from './AirshipLocale';
export { AirshipMessageCenter } from './AirshipMessageCenter';
export { AirshipPreferenceCenter } from './AirshipPreferenceCenter';
export { AirshipPrivacyManager } from './AirshipPrivacyManager';
export { AirshipFeatureFlagManager } from './AirshipFeatureFlagManager';

export { AirshipPush, AirshipPushAndroid, AirshipPushIOS } from './AirshipPush';
export { SubscriptionListEditor } from './SubscriptionListEditor';
export { TagGroupEditor } from './TagGroupEditor';
export { ScopedSubscriptionListEditor } from './ScopedSubscriptionListEditor';
export { AttributeEditor } from './AttributeEditor';

export * from './types';

const plugin = registerPlugin<AirshipPlugin>('Airship', {});

const sharedAirship = new AirshipRoot(new AirshipPluginWrapper(plugin));

const Airship = sharedAirship;
export { Airship };
