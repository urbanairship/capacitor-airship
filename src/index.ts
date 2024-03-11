import { registerPlugin } from '@capacitor/core';

import type { AirshipPlugin } from './plugin';
import { AirshipRoot } from './AirshipRoot';
export { AirshipRoot } from './AirshipRoot';

const plugin = registerPlugin<AirshipPlugin>('AirshipPlugin', {});


const sharedAirship = new AirshipRoot(plugin);

const Airship = sharedAirship;
export { Airship };
