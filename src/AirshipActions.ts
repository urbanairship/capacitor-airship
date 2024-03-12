import { JsonValue } from './types';
import { AirshipPluginWrapper } from './plugin';

/**
 * Airship actions.
 */
export class AirshipActions {
  constructor(private readonly plugin: AirshipPluginWrapper) {}

  /**
   * Runs an Airship action.
   *
   * @param name The name of the action.
   * @param value The action's value.
   * @return A promise that returns the action result if the action
   * successfully runs, or the Error if the action was unable to be run.
   */
  public run(
    actionName: string,
    actionValue?: JsonValue,
  ): Promise<JsonValue | null | undefined> {
    return this.plugin.perform('actions#run', [actionName, actionValue]);
  }
}
