import type {
  ChannelCreatedEvent,
  NotificationResponseEvent,
  PushReceivedEvent,
  DeepLinkEvent,
  MessageCenterUpdatedEvent,
  PushNotificationStatusChangedEvent,
  iOS,
  DisplayMessageCenterEvent,
  DisplayPreferenceCenterEvent,
  PushTokenReceivedEvent,
} from './types';

export enum EventType {
  ChannelCreated = 'channel_created',
  NotificationResponse = 'notification_response_received',
  PushReceived = 'push_received',
  DeepLink = 'deep_link_received',
  MessageCenterUpdated = 'message_center_updated',
  PushNotificationStatusChangedStatus = 'notification_status_changed',
  DisplayMessageCenter = 'display_message_center',
  DisplayPreferenceCenter = 'display_preference_center',
  PushTokenReceived = 'push_token_received',
  IOSAuthorizedNotificationSettingsChanged = 'ios_authorized_notification_settings_changed',
}

export interface EventTypeMap {
  [EventType.ChannelCreated]: ChannelCreatedEvent;
  [EventType.NotificationResponse]: NotificationResponseEvent;
  [EventType.PushReceived]: PushReceivedEvent;
  [EventType.DeepLink]: DeepLinkEvent;
  [EventType.MessageCenterUpdated]: MessageCenterUpdatedEvent;
  [EventType.PushNotificationStatusChangedStatus]: PushNotificationStatusChangedEvent;
  [EventType.IOSAuthorizedNotificationSettingsChanged]: iOS.AuthorizedNotificationSettingsChangedEvent;
  [EventType.DisplayMessageCenter]: DisplayMessageCenterEvent;
  [EventType.DisplayPreferenceCenter]: DisplayPreferenceCenterEvent;
  [EventType.PushTokenReceived]: PushTokenReceivedEvent;
}
