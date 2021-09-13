#!/usr/bin/env node

/* jshint esversion: 8 */
/* global describe */
/* global before */
/* global after */
/* global it */

'use strict';

require('chromedriver');

var execSync = require('child_process').execSync,
    expect = require('expect.js'),
    path = require('path'),
    { Builder, By, Key, until } = require('selenium-webdriver'),
    { Options } = require('selenium-webdriver/chrome');

if (!process.env.USERNAME || !process.env.PASSWORD) {
    console.log('USERNAME and PASSWORD env vars need to be set');
    process.exit(1);
}

describe('Application life cycle test', function () {
    this.timeout(0);

    const LOCATION = 'test';
    const TEST_TIMEOUT = 10000;
    const EXEC_ARGS = { cwd: path.resolve(__dirname, '..'), stdio: 'inherit' };
    const ADMIN_EMAIL = 'admin@cloudron.local';
    const ADMIN_PASSWORD = 'changeme123';
    const USERNAME = process.env.USERNAME;
    const PASSWORD = process.env.PASSWORD;
    const PROJECT_NAME = 'Testproject';
    const PROJECT_WEBSITE = 'https://cloudron.io';

    var browser, app;

    before(function () {
        browser = new Builder().forBrowser('chrome').setChromeOptions(new Options().windowSize({ width: 1280, height: 1024 })).build();
    });

    after(function () {
        browser.quit();
    });

    async function waitForElement(elem) {
        await browser.wait(until.elementLocated(elem), TEST_TIMEOUT);
        await browser.wait(until.elementIsVisible(browser.findElement(elem)), TEST_TIMEOUT);
    }

    function getAppInfo() {
        var inspect = JSON.parse(execSync('cloudron inspect'));
        app = inspect.apps.filter(function (a) { return a.location.indexOf(LOCATION) === 0; })[0];
        expect(app).to.be.an('object');
    }

    async function login(username, password) {
        await browser.get(`https://${app.fqdn}/accounts/login/`);

        await waitForElement(By.id('id_username'));
        await browser.findElement(By.id('id_username')).sendKeys(username);
        await browser.findElement(By.id('id_password')).sendKeys(password);
        await browser.findElement(By.xpath('//input[contains(@value, "Sign in")]')).click();
        await waitForElement(By.xpath('//img[contains(@alt, "User avatar")]'));
    }

    async function logout() {
        await browser.get(`https://${app.fqdn}`);

        await waitForElement(By.id('user-dropdown'));
        await browser.findElement(By.id('user-dropdown')).click();
        await waitForElement(By.id('logout-button'));
        await browser.findElement(By.id('logout-button')).click();
        await waitForElement(By.id('login-button'));
    }

    async function createProject() {
        await browser.get(`https://${app.fqdn}/create/project/`);

        await waitForElement(By.id('id_name'));
        await browser.findElement(By.id('id_name')).sendKeys(PROJECT_NAME);
        await browser.findElement(By.id('id_web')).sendKeys(PROJECT_WEBSITE);
        await browser.findElement(By.xpath('//input[contains(@value, "Save")]')).click();
        await waitForElement(By.xpath(`//a[contains(text(), "${PROJECT_NAME}")]`));
    }

    async function projectExists() {
        await browser.get(`https://${app.fqdn}/projects/${PROJECT_NAME.toLowerCase()}/`);

        await waitForElement(By.xpath(`//a[contains(text(), "${PROJECT_NAME}")]`));
    }

    xit('build app', function () { execSync('cloudron build', EXEC_ARGS); });
    it('install app', function () { execSync(`cloudron install --location ${LOCATION}`, EXEC_ARGS); });

    it('can get app information', getAppInfo);
    it('can user login', login.bind(null, USERNAME, PASSWORD));
    it('can logout', logout);
    it('can admin login', login.bind(null, ADMIN_EMAIL, ADMIN_PASSWORD));
    it('can create project', createProject);
    it('project exists', projectExists);
    it('can logout', logout);

    it('can restart app', function () { execSync(`cloudron restart --app ${app.id}`); });

    it('can user login', login.bind(null, USERNAME, PASSWORD));
    it('can logout', logout);
    it('can admin login', login.bind(null, ADMIN_EMAIL, ADMIN_PASSWORD));
    it('project exists', projectExists);
    it('can logout', logout);

    it('backup app', function () { execSync(`cloudron backup create --app ${app.id}`, EXEC_ARGS); });
    it('restore app', function () {
        const backups = JSON.parse(execSync(`cloudron backup list --raw --app ${app.id}`));
        execSync(`cloudron uninstall --app ${app.id}`, EXEC_ARGS);
        execSync(`cloudron install --location ${LOCATION}`, EXEC_ARGS);
        getAppInfo();
        execSync(`cloudron restore --backup ${backups[0].id} --app ${app.id}`, EXEC_ARGS);
    });

    it('can user login', login.bind(null, USERNAME, PASSWORD));
    it('can logout', logout);
    it('can admin login', login.bind(null, ADMIN_EMAIL, ADMIN_PASSWORD));
    it('project exists', projectExists);
    it('can logout', logout);

    it('move to different location', async function () {
        // ensure we don't hit NXDOMAIN in the mean time
        await browser.get('about:blank');
        execSync(`cloudron configure --location ${LOCATION}2 --app ${app.id}`, EXEC_ARGS);
    });

    it('can get app information', getAppInfo);
    it('can user login', login.bind(null, USERNAME, PASSWORD));
    it('can logout', logout);
    it('can admin login', login.bind(null, ADMIN_EMAIL, ADMIN_PASSWORD));
    it('project exists', projectExists);
    it('can logout', logout);

    it('uninstall app', async function (done) {
        // ensure we don't hit NXDOMAIN in the mean time
        await browser.get('about:blank');
        execSync(`cloudron uninstall --app ${app.id}`, EXEC_ARGS);
    });

    // test update
    it('can install app', function () { execSync(`cloudron install --appstore-id ${app.manifest.id} --location ${LOCATION}`, EXEC_ARGS); });
    it('can get app information', getAppInfo);
    it('can user login', login.bind(null, USERNAME, PASSWORD));
    it('can logout', logout);
    it('can admin login', login.bind(null, ADMIN_EMAIL, ADMIN_PASSWORD));
    it('can create project', createProject);
    it('project exists', projectExists);
    it('can logout', logout);

    it('can update', function () { execSync(`cloudron update --app ${app.id}`, EXEC_ARGS); });

    it('can user login', login.bind(null, USERNAME, PASSWORD));
    it('can logout', logout);
    it('can admin login', login.bind(null, ADMIN_EMAIL, ADMIN_PASSWORD));
    it('project exists', projectExists);
    it('can logout', logout);

    it('uninstall app', async function (done) {
        // ensure we don't hit NXDOMAIN in the mean time
        browser.get('about:blank');
        await execSync(`cloudron uninstall --app ${app.id}`, EXEC_ARGS);
    });
});
