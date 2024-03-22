import type { PluginListenerHandle } from '@capacitor/core';

import type { AttributeOperation } from './AttributeEditor';
import { AttributeEditor } from './AttributeEditor';
import { EventType } from './EventType';
import type {
  SubscriptionListOperation} from './SubscriptionListEditor';
import {
  SubscriptionListEditor
} from './SubscriptionListEditor';
import type { TagOperation } from './TagEditor';
import { TagEditor } from './TagEditor';
import type { TagGroupOperation } from './TagGroupEditor';
import { TagGroupEditor } from './TagGroupEditor';
import type { AirshipPluginWrapper } from './AirshipPlugin';
import type { ChannelCreatedEvent } from './types';




/**
 * Airship channel.
 */
export class AirshipChannel {
  constructor(private readonly plugin: AirshipPluginWrapper) {}

  /**
   * Gets the device tags.
   * @returns A promise with the result.
   */
  public getTags(): Promise<string[]> {
    return this.plugin.perform('channel#getTags');
  }

  /**
   * Gets the channel Id.
   *
   * @returns A promise with the result.
   */
  public getChannelId(): Promise<string | null | undefined> {
    return this.plugin.perform('channel#getChannelId');
  }

  /**
   * Gets a list of the channel's subscriptions.
   * @returns A promise with the result.
   */
  public getSubscriptionLists(): Promise<string[]> {
    return this.plugin.perform('channel#getSubscriptionLists');
  }

  /**
   * Edits tags.
   * @returns A tag group editor.
   */
  public editTags(): TagEditor {
    return new TagEditor((operations: TagOperation[]) => {
      return this.plugin.perform('channel#editTags', operations);
    });
  }
  /**
   * Edits tag groups.
   * @returns A tag group editor.
   */
  public editTagGroups(): TagGroupEditor {
    return new TagGroupEditor((operations: TagGroupOperation[]) => {
      return this.plugin.perform('channel#editTagGroups', operations);
    });
  }

  /**
   * Edits attributes.
   * @returns An attribute editor.
   */
  public editAttributes(): AttributeEditor {
    return new AttributeEditor((operations: AttributeOperation[]) => {
      return this.plugin.perform('channel#editAttributes', operations);
    });
  }

  /**
   * Edits subscription lists.
   * @returns A subscription list editor.
   */
  public editSubscriptionLists(): SubscriptionListEditor {
    return new SubscriptionListEditor(
      (operations: SubscriptionListOperation[]) => {
        return this.plugin.perform('channel#editSubscriptionLists', operations);
      },
    );
  }

  /**
   * Enables channel creation if channel creation has been delayed.
   * It is only necessary to call this when isChannelCreationDelayEnabled
   * has been set to `true` in the airship config.
   * Deprecated. Use the Private Manager to disable all features instead.
   */
  public enableChannelCreation(): Promise<void> {
    return this.plugin.perform('channel#enableChannelCreation');
  }

  /**
   * Adds a channel created listener
   */
  public onChannelCreated(listener: (event: ChannelCreatedEvent) => void): Promise<PluginListenerHandle> {
    return this.plugin.addListener(EventType.ChannelCreated, listener)
  }
}
