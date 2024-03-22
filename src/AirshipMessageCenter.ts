import type { PluginListenerHandle } from '@capacitor/core';

import { EventType } from './EventType';
import type { AirshipPluginWrapper } from './AirshipPlugin';
import type {
  InboxMessage,
  DisplayMessageCenterEvent,
  MessageCenterUpdatedEvent,
} from './types';

/**
 * Airship Message Center
 */
export class AirshipMessageCenter {
  constructor(private readonly plugin: AirshipPluginWrapper) {}

  /**
   * Gets the unread count.
   * @returns A promise with the result.
   */
  public getUnreadCount(): Promise<number> {
    return this.plugin.perform('messageCenter#getUnreadCount');
  }

  /**
   * Gets the inbox messages.
   * @returns A promise with the result.
   */
  public getMessages(): Promise<InboxMessage[]> {
    return this.plugin.perform('messageCenter#getMessages');
  }

  /**
   * Marks a message as read.
   * @param messageId The message Id.
   * @returns A promise. Will reject if the message is not
   * found or if takeOff is not called.
   */
  public markMessageRead(messageId: string): Promise<void> {
    return this.plugin.perform('messageCenter#markMessageRead', messageId);
  }

  /**
   * Deletes a message.
   * @param messageId The message Id.
   * @returns A promise. Will reject if the message is not
   * found or if takeOff is not called.
   */
  public deleteMessage(messageId: string): Promise<void> {
    return this.plugin.perform('messageCenter#deleteMessage', messageId);
  }

  /**
   * Dismisses the OOTB message center if displayed.
   * @returns A promise.
   */
  public dismiss(): Promise<void> {
    return this.plugin.perform('messageCenter#dismiss');
  }

  /**
   * Requests to display the Message Center.
   *
   * Will either emit an event to display the
   * Message Center if auto launch message center
   * is disabled, or display the OOTB message center.
   * @param messageId Optional message Id.
   * @returns A promise.
   */
  public display(messageId?: string): Promise<void> {
    return this.plugin.perform('messageCenter#display', messageId);
  }

  /** 
   * Overlays the message view. Should be used to display the actual
   * message body in a custom Message Center.
   * 
   * @param messageId The message Id.
   * @returns A promise.
   */
  public showMessageView(messageId: string): Promise<void> {
    return this.plugin.perform('messageCenter#showMessageView', messageId);
  }

  /**
   * Refreshes the messages.
   * @returns A promise. Will reject if the list fails to refresh or if
   * takeOff is not called yet.
   */
  public refreshMessages(): Promise<void> {
    return this.plugin.perform('messageCenter#refreshMessages');
  }

  /**
   * Enables or disables showing the OOTB UI when requested to display by either
   * `display` or by a notification with a Message Center action.
   * @param autoLaunch true to show OOTB UI, false to emit events.
   */
  public setAutoLaunchDefaultMessageCenter(autoLaunch: boolean): Promise<void> {
    return this.plugin.perform(
      'messageCenter#setAutoLaunchDefaultMessageCenter',
      autoLaunch,
    );
  }

  /**
   * Adds a display message center listener.
   */
  public onDisplay(
    listener: (event: DisplayMessageCenterEvent) => void,
  ): Promise<PluginListenerHandle> {
    return this.plugin.addListener(EventType.DisplayMessageCenter, listener);
  }

  /**
   * Adds a message center list updated listener.
   */
  public onUpdated(
    listener: (event: MessageCenterUpdatedEvent) => void,
  ): Promise<PluginListenerHandle> {
    return this.plugin.addListener(EventType.MessageCenterUpdated, listener);
  }

}
