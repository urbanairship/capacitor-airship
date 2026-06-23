# Capacitor Airship Plugin

[![npm version](https://badge.fury.io/js/%40ua%2Fcapacitor-airship.svg)](https://badge.fury.io/js/%40ua%2Fcapacitor-airship)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

The official Airship Capacitor plugin for iOS and Android.

## Features

- **Push Notifications** - Rich, interactive push notifications with deep linking
- **Live Activities & Live Updates** - Real-time content updates on iOS Lock Screen and Android Live Content
- **In-App Experiences** - Contextual messaging, automation, and Scenes
- **Embedded Content** - Scene content displayed inline within app screens
- **Message Center** - Persistent inbox for rich messages with HTML, video, and interactive content
- **Preference Center** - User preference management
- **Feature Flags** - Dynamic feature toggles and experimentation
- **Analytics** - Comprehensive user behavior tracking
- **Contacts** - User identification and contact management
- **Tags, Attributes & Subscription Lists** - User segmentation, personalization, and subscription management
- **Privacy Controls** - Granular data collection and feature management

## Quick Start

Install the package:
```bash
npm install @ua/capacitor-airship
npx cap sync
```

### Initialization

Call `takeOff` once during app startup, before any other Airship API:
```typescript
import { Airship } from '@ua/capacitor-airship';

await Airship.takeOff({
  default: {
    appKey: 'YOUR_APP_KEY',
    appSecret: 'YOUR_APP_SECRET',
  },
});

await Airship.push.enableUserNotifications();
```

For a more detailed setup guide, please see the full [Getting Started Documentation](https://docs.airship.com/platform/mobile/setup/sdk/capacitor/).

## Versions and Support

For the current Support Status of each plugin major, EOL dates, and the full lifecycle policy, see the [Airship SDK Support Policy](https://www.airship.com/docs/reference/sdk-support-policy/).

## Resources

- **[Documentation](https://docs.airship.com/platform/mobile/setup/sdk/capacitor/)** - Complete SDK integration guides and feature documentation
- **[API Reference](https://docs.airship.com/reference/libraries/capacitor-airship/latest/)** - Detailed TypeScript API documentation
- **[SDK Support Policy](https://www.airship.com/docs/reference/sdk-support-policy/)** - Version lifecycle, support windows, and EOL dates across all Airship SDKs
- **[GitHub Issues](https://github.com/urbanairship/capacitor-airship/issues)** - Report bugs and request features
- **[Changelog](CHANGELOG.md)** - Release notes and version history
- **[Support](https://support.airship.com/)** - Contact Airship support
