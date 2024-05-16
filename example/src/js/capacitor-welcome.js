import { SplashScreen } from '@capacitor/splash-screen';
import { Airship } from '@ua/capacitor-airship';

window.customElements.define(
  'capacitor-welcome',
  class extends HTMLElement {
    constructor() {
      super();

      SplashScreen.hide();
      window.Airship = Airship;

      const root = this.attachShadow({ mode: 'open' });

      root.innerHTML = `
    <style>
      :host {
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol";
        display: block;
        width: 100%;
        height: 100%;
      }
      h1, h2, h3, h4, h5 {
        text-transform: uppercase;
      }
      .button {
        display: inline-block;
        padding: 10px;
        background-color: #73B5F6;
        color: #fff;
        font-size: 0.9em;
        border: 0;
        border-radius: 3px;
        text-decoration: none;
        cursor: pointer;
      }
      main {
        padding: 15px;
      }
      main hr { height: 1px; background-color: #eee; border: 0; }
      main h1 {
        font-size: 1.4em;
        text-transform: uppercase;
        letter-spacing: 1px;
      }
      main h2 {
        font-size: 1.1em;
      }
      main h3 {
        font-size: 0.9em;
      }
      main p {
        color: #333;
      }
      main pre {
        white-space: pre-line;
      }
    </style>
    <div>
      <capacitor-welcome-titlebar>
        <h1>Capacitor</h1>
      </capacitor-welcome-titlebar>
      <main>
        <p>
          Capacitor makes it easy to build powerful apps for the app stores, mobile web (Progressive Web Apps), and desktop, all
          with a single code base.
        </p>
        <h2>Getting Started</h2>
        <p>
          You'll probably need a UI framework to build a full-featured app. Might we recommend
          <a target="_blank" href="http://ionicframework.com/">Ionic</a>?
        </p>
        <p>
          Visit <a href="https://capacitorjs.com">capacitorjs.com</a> for information
          on using native features, building plugins, and more.
        </p>
        <a href="https://capacitorjs.com" target="_blank" class="button">Read more</a>
        <h2>Tiny Demo</h2>
        <p>
          This demo shows how to call Capacitor plugins. Say cheese!
        </p>
        <p>
          <button class="button" id="enable-push">Toggle push</button>
        </p>
        <p>
          <button class="button" id="display-message-center">Display message center</button>
        </p>
        <p>
            <button class="button" id="display-preference-center">Display preference center</button>
        </p>
        <p id="status-event">
        </p>
      </main>
    </div>
    `;
    }

    connectedCallback() {
      const self = this;

      self.shadowRoot.querySelector('#enable-push').addEventListener('click', async function (e) {
        const isEnabled = await Airship.push.isUserNotificationsEnabled()
        await Airship.push.setUserNotificationsEnabled(!isEnabled)
      });
        
      self.shadowRoot.querySelector('#display-message-center').addEventListener('click', async function (e) {
        await Airship.messageCenter.display()
      });
        
      self.shadowRoot.querySelector('#display-preference-center').addEventListener('click', async function (e) {
        await Airship.preferenceCenter.display("neat")
      });
    }
  }
);

window.onload = async function() {
  await Airship.onDeepLink(event => {
    console.log("onDeepLink", JSON.stringify(event))
  });

  await Airship.push.onNotificationResponse(event => {
    console.log("push.onNotificationResponse", JSON.stringify(event))
  });

  await Airship.push.onNotificationStatusChanged(event => {
    console.log("push.onNotificationStatusChanged", JSON.stringify(event))
  });

  await Airship.push.onPushReceived(event => {
    console.log("push.onPushReceived", JSON.stringify(event))
  });

  await Airship.push.onPushTokenReceived(event => {
    console.log("push.onPushTokenReceived", JSON.stringify(event))
  });

  await Airship.channel.onChannelCreated(event => {
    console.log("channel.onChannelCreated", JSON.stringify(event))
  });

  await Airship.messageCenter.onUpdated(event => {
    console.log("messageCenter.onUpdated", JSON.stringify(event))
  });

  await Airship.messageCenter.onDisplay(event => {
    console.log("messageCenter.onDisplay", JSON.stringify(event))
  });

  await Airship.preferenceCenter.onDisplay(event => {
    console.log("preferenceCenter.onDisplay", JSON.stringify(event))
  });

  await Airship.push.iOS.onAuthorizedSettingsChanged(event => {
    console.log("push.onAuthorizedSettingsChanged", JSON.stringify(event))
  });
};


window.customElements.define(
  'capacitor-welcome-titlebar',
  class extends HTMLElement {
    constructor() {
      super();
      const root = this.attachShadow({ mode: 'open' });
      root.innerHTML = `
    <style>
      :host {
        position: relative;
        display: block;
        padding: 15px 15px 15px 15px;
        text-align: center;
        background-color: #73B5F6;
      }
      ::slotted(h1) {
        margin: 0;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol";
        font-size: 0.9em;
        font-weight: 600;
        color: #fff;
      }
    </style>
    <slot></slot>
    `;
    }
  }
);
