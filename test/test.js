#!/usr/bin/env node

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

    function waitForElement(elem) {
        return browser.wait(until.elementLocated(elem), TEST_TIMEOUT).then(function () {
            return browser.wait(until.elementIsVisible(browser.findElement(elem)), TEST_TIMEOUT);
        });
    }

    function getAppInfo() {
        var inspect = JSON.parse(execSync('cloudron inspect'));
        app = inspect.apps.filter(function (a) { return a.location.indexOf(LOCATION) === 0; })[0];
        expect(app).to.be.an('object');
    }

    function login(username, password, callback) {
        browser.get(`https://${app.fqdn}/accounts/login/`).then(function () {
            return waitForElement(By.id('id_username'));
        }).then(function () {
            return browser.findElement(By.id('id_username')).sendKeys(username);
        }).then(function () {
            return browser.findElement(By.id('id_password')).sendKeys(password);
        }).then(function () {
            return browser.findElement(By.xpath('//input[contains(@value, "Sign in")]')).click();
        }).then(function () {
            return waitForElement(By.xpath('//img[contains(@alt, "User avatar")]'));
        }).then(function () {
            callback();
        });
    }

    function logout(callback) {
        browser.get(`https://${app.fqdn}`).then(function () {
            return waitForElement(By.id('user-dropdown'));
        }).then(function () {
            return browser.findElement(By.id('user-dropdown')).click();
        }).then(function () {
            return waitForElement(By.id('logout-button'));
        }).then(function () {
            return browser.findElement(By.id('logout-button')).click();
        }).then(function () {
            return waitForElement(By.id('login-button'));
        }).then(function () {
            callback();
        });
    }

    function createProject(callback) {
        browser.get(`https://${app.fqdn}/create/project/`).then(function () {
            return waitForElement(By.id('id_name'));
        }).then(function () {
            return browser.findElement(By.id('id_name')).sendKeys(PROJECT_NAME);
        }).then(function () {
            return browser.findElement(By.id('id_web')).sendKeys(PROJECT_WEBSITE);
        }).then(function () {
            return browser.findElement(By.xpath('//input[contains(@value, "Save")]')).click();
        }).then(function () {
            return waitForElement(By.xpath(`//a[contains(text(), "${PROJECT_NAME}")]`));
        }).then(function () {
            callback();
        });
    }

    function projectExists(callback) {
        browser.get(`https://${app.fqdn}/projects/${PROJECT_NAME.toLowerCase()}/`).then(function () {
            return waitForElement(By.xpath(`//a[contains(text(), "${PROJECT_NAME}")]`));
        }).then(function () {
            callback();
        });
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

    it('move to different location', function (done) {
        // ensure we don't hit NXDOMAIN in the mean time
        browser.get('about:blank').then(function () {
            execSync(`cloudron configure --location ${LOCATION}2 --app ${app.id}`, EXEC_ARGS);
            done();
        });
    });

    it('can get app information', getAppInfo);
    it('can user login', login.bind(null, USERNAME, PASSWORD));
    it('can logout', logout);
    it('can admin login', login.bind(null, ADMIN_EMAIL, ADMIN_PASSWORD));
    it('project exists', projectExists);
    it('can logout', logout);

    it('uninstall app', function (done) {
        // ensure we don't hit NXDOMAIN in the mean time
        browser.get('about:blank').then(function () {
            execSync(`cloudron uninstall --app ${app.id}`, EXEC_ARGS);
            done();
        });
    });

    // test update
    // it('can install app', function () { execSync(`cloudron install --appstore-id net.freescout.cloudronapp --location ${LOCATION}`, EXEC_ARGS); });
    // it('can get app information', getAppInfo);
    // it('can login', login);
    // it('can create mailbox', createMailbox);
    // it('mailbox exists', mailboxExists);
    // it('can logout', logout);

    // it('can update', function () { execSync(`cloudron update --app ${app.id}`, EXEC_ARGS); });

    // it('can login', login);
    // it('mailbox exists', mailboxExists);
    // it('can logout', logout);

    // it('uninstall app', function (done) {
    //     // ensure we don't hit NXDOMAIN in the mean time
    //     browser.get('about:blank').then(function () {
    //         execSync(`cloudron uninstall --app ${app.id}`, EXEC_ARGS);
    //         done();
    //     });
    // });
});
