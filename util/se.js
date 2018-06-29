const Canvas = require('canvas');
const Image = Canvas.Image;
const BASE64_IMAGE_PREFIX = 'data:image/png;base64,'; // eslint-disable-line id-match
const WebDriver = require('selenium-webdriver');
const byCss = WebDriver.By.css;

const screen = {

    /**
     *
     * @param {Object} driver - selenium web driver
     * @param {number} width - of browser include borders
     * @param {number} height - of browser include borders
     * @return {Promise} will resolve when site has been set
     */
    setSize: (driver, width, height) => driver.manage().window().setSize(width, height),

    /**
     *
     * @param {Object} driver - selenium web driver
     * @param {number} scrollSize - of body top
     * @return {Promise} will resolve when body has been scrolled
     */
    setScrollTop: (driver, scrollSize) => driver
        .executeScript('document.body.scrollTop = ' + scrollSize)
        .then(() => screen.getScrollTop(driver)),

    /**
     *
     * @param {Object} driver - selenium web driver
     * @param {number} scrollSize - of body left
     * @return {Promise} will resolve when body has been scrolled
     */
    setScrollLeft: (driver, scrollSize) => driver
        .executeScript('document.body.scrollLeft = ' + scrollSize)
        .then(() => screen.getScrollLeft(driver)),

    /**
     *
     * @param {Object} driver - selenium web driver
     * @return {Promise} will resolve with current top scroll
     */
    getScrollTop: driver => driver
        .executeScript('return document.body.scrollTop')
        .then(scrollSize => parseInt(scrollSize, 10)),

    /**
     *
     * @param {Object} driver - selenium web driver
     * @return {Promise} will resolve with current left scroll
     */
    getScrollLeft: driver => driver
        .executeScript('return document.body.scrollLeft')
        .then(scrollSize => parseInt(scrollSize, 10)),

    /**
     *
     * @param {Object} driver - selenium web driver
     * @param {Object} dimensions - of screen shot
     * @param {number} [dimensions.x] - X of elem
     * @param {number} [dimensions.y] - Y of elem
     * @param {number} dimensions.width - width of elem
     * @param {number} dimensions.height - height of elem
     * @return {Promise} will resolve with image in base64
     */
    ofArea: (driver, dimensions) => {
        const {x = 0, y = 0, width, height} = dimensions; // eslint-disable-line id-length

        return Promise
            .all([
                screen.setScrollTop(driver, y),
                screen.setScrollLeft(driver, x)
            ])
            .then(([scrollY, scrollX]) =>
                driver.takeScreenshot().then(image => {
                    const deltaScrollTop = y - scrollY;
                    const deltaScrollLeft = x - scrollX;
                    const canvas = new Canvas(width, height);
                    const ctx = canvas.getContext('2d');
                    const img = new Image();

                    img.src = BASE64_IMAGE_PREFIX + image; // eslint-disable-line id-match

                    ctx.drawImage(img, -deltaScrollLeft, -deltaScrollTop, img.width, img.height);

                    return canvas.toDataURL();
                })
            );
    },

    /**
     *
     * @param {Object} driver - selenium web driver
     * @param {Object} element - for screen shot
     * @return {Promise} will resolve with image in base64
     */
    ofElement: (driver, element) => Promise
        .all([element.getLocation(), element.getSize()])
        .then(([{x, y}, {width, height}]) => screen.ofArea(driver, {x, y, width, height})), // eslint-disable-line id-length

    /**
     *
     * @param {Object} driver - selenium web driver
     * @param {string} selector - for screen shot
     * @return {Promise} will resolve with image in base64
     */
    ofSelector: (driver, selector) => driver.findElement(byCss(selector)).then(elem => screen.ofElement(driver, elem))

};

module.exports.screen = screen;
