import {
  LiveUpdate,
  LiveUpdateListRequest,
  LiveUpdateStartRequest,
  LiveUpdateUpdateRequest,
  LiveUpdateEndRequest,
} from './types';

import type { AirshipPluginWrapper } from './AirshipPlugin';

/**
 * Live Update manager.
 */
export class AirshipLiveUpdateManager {
  constructor(private readonly plugin: AirshipPluginWrapper) {}

  /**
   * Lists any Live Updates for the request.
   * @param request The request options.
   * @returns A promise with the result.
   */
  public list(request: LiveUpdateListRequest): Promise<LiveUpdate[]> {
    return this.plugin.perform('liveUpdateManager#list', request);
  }

  /**
   * Lists all Live Updates.
   * @returns A promise with the result.
   */
  public listAll(): Promise<LiveUpdate[]> {
    return this.plugin.perform('liveUpdateManager#listAll');
  }

  /**
   * Starts a Live Update.
   * @param request The request options.
   * @returns A promise with the result.
   */
  public start(request: LiveUpdateStartRequest): Promise<void> {
    return this.plugin.perform('liveUpdateManager#start', request);
  }

  /**
   * Updates a Live Update.
   * @param request The request options.
   * @returns A promise with the result.
   */
  public update(request: LiveUpdateUpdateRequest): Promise<void> {
    return this.plugin.perform('liveUpdateManager#update', request);
  }

  /**
   * Ends a Live Update.
   * @param request The request options.
   * @returns A promise with the result.
   */
  public end(request: LiveUpdateEndRequest): Promise<void> {
    return this.plugin.perform('liveUpdateManager#end', request);
  }

  /**
   * Clears all Live Updates.
   * @returns A promise with the result.
   */
  public clearAll(): Promise<void> {
    return this.plugin.perform('liveUpdateManager#clearAll');
  }
}

