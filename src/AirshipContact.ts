import { AttributeEditor, AttributeOperation } from './AttributeEditor';
import {
  ScopedSubscriptionListEditor,
  ScopedSubscriptionListOperation,
} from './ScopedSubscriptionListEditor';
import { TagGroupEditor, TagGroupOperation } from './TagGroupEditor';
import { SubscriptionScope } from './types';
import { AirshipPluginWrapper } from './plugin';

/**
 * Airship contact.
 */
export class AirshipContact {
  constructor(private readonly plugin: AirshipPluginWrapper) {}

  /**
   * Identifies the contact with a named user Id.
   * @param namedUser The named user Id.
   * @returns A promise.
   */
  public identify(namedUser: string): Promise<void> {
    return this.plugin.perform('contact#identify', namedUser);
  }

  /**
   * Resets the contact.
   * @returns A promise.
   */
  public reset(): Promise<void> {
    return this.plugin.perform('contact#reset');
  }

  /**
   * Gets the named user Id.
   * @returns A promise with the result.
   */
  public getNamedUserId(): Promise<string | null | undefined> {
    return this.plugin.perform('contact#getNamedUserId');
  }

  /**
   * Gets the contacts subscription lists.
   * @returns A promise with the result.
   */
  public getSubscriptionLists(): Promise<Record<string, SubscriptionScope[]>> {
    return this.plugin.perform('contact#getSubscriptionLists');
  }

  /**
   * Edits tag groups.
   * @returns A tag group editor.
   */
  public editTagGroups(): TagGroupEditor {
    return new TagGroupEditor((operations: TagGroupOperation[]) => {
      return this.plugin.perform('contact#editTagGroups', operations);
    });
  }

  /**
   * Edits attributes.
   * @returns An attribute editor.
   */
  public editAttributes(): AttributeEditor {
    return new AttributeEditor((operations: AttributeOperation[]) => {
      return this.plugin.perform('contact#editAttributes', operations);
    });
  }

  /**
   * Edits subscription lists.
   * @returns A subscription list editor.
   */
  public editSubscriptionLists(): ScopedSubscriptionListEditor {
    return new ScopedSubscriptionListEditor(
      (operations: ScopedSubscriptionListOperation[]) => {
        return this.plugin.perform('contact#editSubscriptionLists', operations);
      },
    );
  }
}
