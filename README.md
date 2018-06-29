# se-core
Selenium Web Driver Auto Test Core.

## About
Package depends of 'canvas' (https://www.npmjs.com/package/canvas), so, you have to install canvas dependencies.

You can quickly install the dependencies by using the command for your OS:

OS | Command
----- | -----
OS X | Using [Homebrew](https://brew.sh/):<br/>`brew install pkg-config cairo pango libpng jpeg giflib`<br/><br/>Using [MacPorts](https://www.macports.org/):<br/>`port install pkgconfig cairo pango libpng jpeg giflib`
Ubuntu | `sudo apt-get install libcairo2-dev libjpeg-dev libpango1.0-dev libgif-dev build-essential g++`
Fedora | `sudo yum install cairo cairo-devel cairomm-devel libjpeg-turbo-devel pango pango-devel pangomm pangomm-devel giflib-devel`
Solaris | `pkgin install cairo pango pkg-config xproto renderproto kbproto xextproto`
Windows | [Instructions on our wiki](https://github.com/Automattic/node-canvas/wiki/Installation---Windows)

**Mac OS X v10.11+:** If you have recently updated to Mac OS X v10.11+ and are experiencing trouble when compiling, run the following command: `xcode-select --install`. Read more about the problem [on Stack Overflow](http://stackoverflow.com/a/32929012/148072).

## Example
```javascript
/* global describe, it, before, after, beforeEach, afterEach, process */

// !!! use process.env for example only
// SE_SERVER_PORT, IS_MOBILE and BROWSER_NAME needed for selenium server
process.env.SE_SERVER_PORT = 4444;
process.env.IS_MOBILE = '';
process.env.BROWSER_NAME = 'chrome';

const {assert} = require('chai');
const WebDriver = require('selenium-webdriver');
const addContext = require('mochawesome/addContext');
const {SeleniumServer} = require('selenium-webdriver/remote');
const {seUtil, testUtil} = require('se-core');

const {mainConfig} = require('./../test-config/main-config.js');
const envData = testUtil.getEnvData();
const server = new SeleniumServer(...testUtil.getSeleniumServerArgs());
const until = WebDriver.until;
const byCss = WebDriver.By.css;
let driver = null;

const selector = {
    iFrame: 'iframe-css-selector',
    loader: 'loader-css-selector'
};

describe('Load', () => {
    if (!envData.isMobile) {
        before(async () => server.start());
    }

    after(async () => server.stop());

    beforeEach(async () => {
        driver = new WebDriver
            .Builder()
            .usingServer(envData.wdServerUrl)
            .withCapabilities(testUtil.getCapabilities())
            .build();

        if (!envData.isMobile) {
            await seUtil.screen.setSize(driver, 1024, 768);
        }
    });

    afterEach(async () => driver.quit());


    it('Load iFrame', async function loadIFrame() {
        await driver.get(mainConfig.url.host + mainConfig.url.pathname);

        // wait to create loader
        const loader = await driver.wait(until.elementLocated(byCss(selector.loader)), 5e3);

        // wait to hide loader
        await driver.wait(until.elementIsNotVisible(loader), 10e3);

        // wait to create iFrame
        const iFrame = await driver.wait(until.elementLocated(byCss(selector.iFrame)), 5e3);

        // wait to show iFrame
        await driver.wait(until.elementIsVisible(iFrame), 5e3);

        const image = await seUtil.screen
            .ofSelector(driver, selector.iFrame);

        addContext(this, image); // eslint-disable-line no-invalid-this
    }).timeout(30e3);

});
```
