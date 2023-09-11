[0.1.0]
* initial version

[0.2.0]
* Update Weblate to 4.3
* Include user stats in the API.
* Fixed component ordering on paginated pages.
* Define source language for a glossary.
* Rewritten support for GitHub and GitLab pull requests.
* Fixed stats counts after removing suggestion.
* Extended public user profile.
* Fixed configuration of enforced checks.
* Improve documentation about built-in backups.
* Moved source language attribute from project to a component.
* Add Vue I18n formatting check.
* Generic placeholders check now supports regular expressions.
* Improved look of matrix mode.
* Machinery is now called automatic suggestions.
* Added support for interacting with multiple GitLab or GitHub instances.
* Extended API to cover project updates, unit updates and removals and glossaries.
* Unit API now properly handles plural strings.

[0.3.0]
* Increase minimal memory limit
* Add /app/data/.celery.env file to override worker options

[1.0.0]
* Update Weblate to 4.3.1
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.3.1)
* Improved automatic translation performance.
* Fixed session expiry for authenticated users.
* Add support for hiding version information.
* Improve hooks compatibility with Bitbucket Server.
* Improved translation memory updates performance.
* Reduced memory usage.
* Improved performance of matrix view.
* Added confirmation before removing user from a project.

[1.0.1]
* Remove celery beat pidfile usage
* Increase minimal memory limit

[1.0.2]
* Add new celery memory worker

[1.0.3]
* Fix user invitation

[1.1.0]
* Update Weblate to 4.4
* Improved validation when creating component.
* Weblate now requires Django 3.1.
* Added support for appearance customization in the management interface.
* Fixed read only state handling in bulk edit.
* Improved CodeMirror integration.
* Added addon to remove blank strings from translation files.
* The CodeMirror editor is now used for translations.
* Syntax highlighting in translation editor for XML, HTML, Markdown and reStructuredText.
* Highlight placeables in translation editor.
* Improved support for non standard language codes.
* Added alert on using ambiguous language codes.
* User is now presented filtered list of languages when adding new translation.
* Extended search capabilities for changes history.
* Improved billing detail pages and libre hosting workflow.
* Extended translation statistics API.
* Improved other translations tab while translating.
* Added tasks API.
* Improved file upload performance.
* Improved display of user defined special characters.
* Improved auto translate performance.
* Several minor user interface improvements.
* Improved naming of ZIP downloads.
* Added option for getting notifications on unwatched projects.

[1.1.1]
* Fix memory celery worker

[1.1.2]
* Update Weblate to 4.4.1
* Fixed reverting plural changes.
* Fixed displaying help for project settings.
* Improved administration of users.
* Improved handling of context in monolingual PO files.
* Fixed cleanup addon behavior with HTML, ODF, IDML and Windows RC formats.
* Fixed parsing of location from CSV files.
* Use content compression for file downloads.
* Improved user experience on importing from ZIP file.
* Improved detection of file format for uploads.
* Avoid duplicate pull requests on Pagure.
* Improved performance when displaying ghost translations.
* Reimplemented translation editor to use native browser textarea.
* Fixed cleanup addon breaking adding new strings.
* Added API for addons.

[1.1.3]
* Update Weblate to 4.4.2
* Fixed corruption of one distributed MO file.

[1.2.0]
* Update Weblate to 4.5
* Update to base image v3
* Added support for lua-format used in gettext PO.
* Added support for sharing a component between projects.
* Fixed multiple unnamed variables check behavior with multiple format flags.
* Dropped mailing list field on the project in favor of generic instructions for translators.
* Added pseudolocale generation addon.
* Added support for TermBase eXchange files.
* Added support for manually defining string variants using a flag.
* Improved performance of consistency checks.
* Improved performance of translation memory for long strings.
* Added support for searching in explanations.
* Strings can now be added and removed in bilingual formats as well.
* Extend list of supported languages in Amazon Translate machine translation.
* Automatically enable Java MessageFormat checks for Java Properties.
* Added a new upload method to add new strings to a translation.
* Added a simple interface to browse translation.
* Glossaries are now stored as regular components.
* Dropped specific API for glossaries as component API is used now.
* Added simplified interface to toggle some of the flags.
* Added support for non-translatable or forbidden terms in the glossary.
* Added support for defining terminology in a glossary.
* Moved text direction toggle to get more space for the visual keyboard.
* Added option to automatically watch projects user-contributed to.
* Added check whether translation matches the glossary.
* Added support for customizing navigation text color.

[1.2.1]
* Update Weblate to 4.5.1
* Fixed editing of glossary flags in some corner cases.
* Extend metrics usage to improve performance of several pages.
* Store correct source language in TMX files.
* Better handling for uploads of monolingual PO using API.
* Improved alerts behavior glossaries.
* Improved Markdown link checks.
* Indicate glossary and source language in breadcrumbs.
* Paginated component listing of huge projects.
* Improved performance of translation, component or project removal.
* Improved bulk edit performance.
* Fixed preserving "Needs editing" and "Approved" states for ODF files.
* Improved interface for customizing translation-file downloads

[1.2.2]
* Update Weblate to 4.5.2
* Configurable schedule for automatic translation.
* Added Lua format check.
* Ignore format strings in the :ref:check-duplicate check.
* Allow uploading screenshot from a translate page.
* Added forced file synchronization to the repository maintenance.
* Fixed automatic suggestions for languages with a longer code.
* Improved performance when adding new strings.
* Several bug fixes in quality checks.
* Several performance improvements.
* Added integration with :ref:discover-weblate.
* Fixed checks behavior with read-only strings.

[1.2.3]
* Update Weblate to 4.5.3
* Fixed metrics collection.
* Fixed possible crash when adding strings.
* Improved search query examples.
* Fixed possible loss of newly added strings on replace upload.

[1.2.4]
* Update Weblate to 4.6
* The auto_translate management command has now a parameter for specifying translation mode.
* Added support for TXT files.
* Added trends and metrics for all objects.
* Added support for direct copying text from secondary languages.
* Added date filtering when browsing changes.
* Improved activity charts.
* Sender for contact form e-mails can now be configured.
* Improved parameters validation in component creation API.
* The rate limiting no longer applies to superusers.
* Improved automatic translation addon performance and reliability.
* The rate limiting now can be customized in the Docker container.
* API for creating components now automatically uses Weblate internal URLs.
* Simplified state indication while listing strings.
* Password hashing now uses Argon2 by default.
* Simplified progress bars indicating translation status.
* Renamed Add missing languages addon to clarify the purpose.
* Fixed saving string state to XLIFF.
* Added language-wide search.
* Initial support for scaling horizontall the Docker deployment.

[1.2.5]
* Update Weblate to 4.6.1
* Remove obsolete spam protection code.
* Improve source plural check accuracy.
* Update list of user interface languages in Docker.
* Improved error messages when creating pull requests.
* Fixed creating pull requests on Pagure.
* Fixed triggering automatically installed add-ons.
* Fixed possible caching issues on upgrade.
* Fixed adding new units to monolingual translations using upload.

[1.2.6]
* Update Weblate to 4.6.2
* Fixed crash after moving shared component between projects.
* Fixed adding new strings to empty properties files.
* Fixed copy icon alignment in RTL languages.
* Extended string statistics on the Info tab.
* Fixed handling of translation files ignored in Git.
* Improved metrics performance.
* Fixed possible bug in saving glossaries.
* Fixed consistency check behavior on languages with different plural rules.

[1.3.0]
* Update Weblate to 4.7
* Improved configuration health check.
* Added support for object-pascal-format used in gettext PO, see :ref:check-object-pascal-format.
* Renamed :guilabel:Nearby keys to :guilabel:Similar keys to better describe the purpose.
* Added support for :ref:mi18n-lang.
* Improved SAML authentication integration.
* Fixed :ref:vcs-gerrit integration to better handle corner cases.
* Weblate now requires Django 3.2.
* Fixed inviting users when e-mail authentication is disabled.
* Improved language definitions.
* Added support for blocking users from contributing to a project.
* Fixed automatic creation of glossary languages.
* Extended documentation about add-ons.
* Performance improvements for components with linked repositories.
* Added support for free DeepL API.
* The user management no longer needs Django admin interface.

[1.3.1]
* Update Weblate to 4.7.1
* Improved popup for adding terms to glossary.
* Added support for LibreTranslate machine translation service.
* Added rate limiting on creating new projects.
* Improved performance of file updates.

[1.3.2]
* Update Weblate to 4.7.2
* Support more language aliases to be configured on a project.
* Fixed search string validation in API.
* Fixed Git exporter URLs after a domain change.
* Fixed cleanup addon for Windows RC files.
* Fixed possible crash on Xliff updating.

[1.4.0]
* Update Weblate to 4.8.0
* Added support for Apple stringsdict format.
* The exact search operator is now case-sensitive on PostgreSQL.
* Fixed saving glossary explanations in some cases.
* Documentation improvements.
* Performance improvements.
* Improved squash add-on compatibility with Gerrit.
* Fixed adding strings to a monolingual glossary components.
* Improved performance in hadling variants.
* Fixed squash add-on sometimes skipping parsing upstream changes.
* Preserve file extension on download.
* Added support for the Fluent format.
* Add support for using tabs to indent JSON formats.

[1.4.1]
* Update Weblate to 4.8.1
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.8.1)
* Fixed user removal in Django admin interface.
* Document add-on parameters in more detail.
* Fixed JavaScript error on glossary.
* Add limit to number of matches in consistency check.
* Improve placeholders handling in machine translations.
* Fixed creating add-ons using API.
* Added :setting:PRIVACY_URL setting to add privacy policy link to the footer.
* Hide member e-mail addresses from project admins.
* Improved gettext PO merging in case of conflicts.
* Improved glossary highlighting.
* Improved safe-html flag behavior with XML checks.
* Fixed commit messages on linked components.

[1.5.0]
* Update Weblate to 4.9
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.9)
* Provide more details for history events.
* Improved rendering of history.
* Improved performance of the translation pages.
* Added support for restricting translation file download.
* The safe-html can now understand Markdown when used with md-text.
* The max-length tag now ignores XML markup when used with xml-text.
* Fixed dimensions of rendered texts in :ref:check-max-size.
* Lowered app store title length to 30 to assist with upcoming Google policy changes.
* Added support for customising ssh invocation via :setting:SSH_EXTRA_ARGS.
* Added checks for ICU MessageFormat.
* Improved error condition hadling in machine translation backends.
* Highlight unusual whitespace characters in the strings.
* Added option to stay on translated string while editing.
* Added support for customising borg invocation via :setting:BORG_EXTRA_ARGS.
* Fixed generating of MO files for monolingual translations.
* Added API endpoint to download all component translations in a ZIP file.
* Added support for resending e-mail invitation from the management interface.

[1.5.1]
* Update Weblate to 4.9.1
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.9.1)
* Fixed upload of monolingual files after changing template.
* Improved handling of whitespace in flags.
* Add support for filtering in download API.
* Fixed statistics display when adding new translations.
* Mitigate issues with GitHub SSH key change.

[1.6.0]
* Update Weblate to 4.10.0
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.10)
* Update base image to 3.2.0
* Added support for formality and placeholders with DeepL.
* Bulk edit and search and replace are now available on project and language level.
* Added filtering to search and replace.
* Fixed: "Perform automatic translation" privilege is no longer part of the Languages group.
* "Perform automatic translation" is in the Administration and the new Automatic translation group.
* Fixed generating XLSX files with special chars.
* Added ability to the GitHub authentication backend to check if the user belongs to a specific GitHub organization or team.
* Improved feedback on invalid parameters passed to API.
* Added support for project scoped access tokens for API.
* Fixed string removal in some cases.
* Fixed translating newly added strings.
* Label automatically translated strings to ease their filtering.

[1.6.1]
* Update Weblate to 4.10.1
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.10.1)
* Documented changes introduced by upgrading to Django 4.0.
* Fixed displaying of :guilabel:Automatically translated label.
* Fixed API display of branch in components with a shared repository.
* Improved analysis on the failed push alert.
* Fixed manually editing page when browsing changes.
* Improved accuracy of :ref:check-kashida.

[1.6.2]
* Update Weblate to 4.11
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.11)

[1.6.3]
* Update Weblate to 4.11.2
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.11.2)
* Fixed corrupted MO files in the binary release.
* Fixed missing sanitizing of arguments to Git and Mercurial - CVE-2022-23915, see GHSA-3872-f48p-pxqj <https://github.com/WeblateOrg/weblate/security/advisories/GHSA-3872-f48p-pxqj>_ for more details.
* Fixed loading fuzzy strings from CSV files.
* Added support for creating teams using the API.
* Fixed user mention suggestions display.
* The project tokens access can now be customized.

[1.7.0]
* Update Weblate to 4.12
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.12)
* Added support for Amharic in :ref:check-end-stop.
* Added support for Burmese in :ref:check-end-question.
* Extended options of the :ref:addon-weblate.generate.pseudolocale add-on.
* Added ignore-all-checks flag to ignore all quality checks on a string.
* Avoid :ref:addon-weblate.generate.pseudolocale add-on to trigger failing checks.
* Added support for :ref:vcs-gitea.
* Added Linux style language code to :ref:component-language_code_style.
* Added support for rebuilding project translation memory.
* Improved API for creating components from a file.
* Add copy and clone buttons to other translations.
* Make merge request message configurable at component level.
* Improved maximal length restriction behavior with XML tags.
* Fixed loading Fluent files with additional comments.

[1.7.1]
* Update Weblate to 4.12.1
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.12.1)
* Fixed pull request message title.
* Improved syntax error handling in Fluent format.
* Fixed avatar display in notification e-mails.
* Add support for web monetization.
* Fixed removal of stale source strings when removing translations.

[1.7.2]
* Update Weblate to 4.12.2
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.12.2)
* Fixed rebuilding project translation memory for some components.
* Fixed sorting components by untranslated strings.
* Fixed possible loss of translations while adding new language.
* Ensure Weblate SSH key is generated during migrations.

[1.8.0]
* Update Weblate to 4.13
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.13)
* Changed behavior of updating language names.
* Added pagination to projects listing.
* API for creating new units now returns information about newly created unit.
* Component discovery now supports configuring an intermediate language.
* Added fixed encoding variants to CSV formats.
* Changed handling of context and location for some formats to better fit underlying implementation.
* Added support for ResourceDictionary format.

[1.8.1]
* Update Weblate to 4.13.1
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.13.1)
* Fixed tracking suggestions in history.
* Fixed parsing reverse proxy info from Cloudflare.
* Make parse error lock a component from translating.
* Fixed configuring intermediate file in the discovery add-on.
* Fixed DeepL translations behvior with placeholders.
* Fixed untranslating strings via API.
* Added support for removing user from a group via API.
* Fixed audit log for user invitation e-mails.

[1.8.2]
* Install all optional dependencies for better compatibility

[1.9.0]
* Update Weblate to 4.14
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.14)
* Track add-on changes in a history.
* Fixed parsing translation from Windows RC, HTML and text files.
* Extended language code style configuration options.
* Added support for pluralse updated in recent CLDR releases.
* Reduced memory usage while updating components with a lot of
* translations.
* Added support for translation domain in SAP Translation Hub.
* Allow absolute links in source string locations.
* Improved operation behind some reverse proxies.
* Exteded API to cover translation memory.
* Improved document translation workflow.
* Improved reliability of HTML and text files translation.
* Added support for project level backups.
* Improved performance and memory usage of translation memory lookups.

[1.9.1]
* Update Weblate to 4.14.1
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.14.1)
* Fixed generating project backups in some situations.
* Improved error reporting on file upload.
* Fetch all user verified e-mails from GitHub during authentication.
* Avoid matching glossary terms on context or keys.
* Added notifications for string removals.
* Improved management of untranslatable terms in glossary.
* List number of team members on team management page.
* Add group management interface.
* Always show review stats when reviews are enabled.
* Added searching support in units API.
* Fixed progress bar display for read-only strings in the review
* workflow.
* Improved Burmese punctuation check.
* Fixed garbage collecting of metrics data.

[1.9.2]
* Fix app when not using Cloudron user directory

[1.9.3]
* Update Weblate to 4.14.2
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.14.2)
* Added support for removing entries from translation memory.
* Improved analysis on the duplicate language alert.
* Improved accurancy of the consecutive duplicated words check.
* Improved scaling of sending many notifications.
* Improved string state handling for subtitle translation.
* Deprecated insecure configuration of VCS service API keys via
* `_TOKEN/_USERNAME` configuration instead of `_CREDENTIALS` list.
* Fixed processing of some uploaded CSV files.
* Improved whitespace changes handling in diff display.
* Added automatic suggestions management link to management pages.
* Track comment removal/resolving in history.
* Fixed restoring project backups with linked components.
* Fixed captcha entering on unsuccessful registration.
* Improved languages support in DeepL.
* Improved webhooks compatibility with authenticated repositories.
* Added support for Python 3.11.

[1.10.0]
* Update Weblate to 4.15.0
* Update Cloudron base image to 4.0.0
* Make the app compatible with redis 6
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.15)
* Added support for browsing changes for a individual string.
* Fixed plurals handling in automatic translation from other components.
* Added keyboard shortcut Alt+Enter to submit string as a suggestion.
* Added support for placeables in the Fluent format.
* Improved performance of translation memory.
* Autogenerate repoweb browsing links for well known code hosting services.
* Improved performance of several views.
* Improved listing of strings with plurals.
* Added support for adding custom markup to HTML head.
* Fixed generation of MO files in the add-on to include only translated files.
* Fixed rendering of regular expression flags.
* Improved placeholders check behavior with plurals.
* Added support for translation files naming suitable for Google Play.
* Added support for labels in API.
* Added support for choosing different e-mail for commits than for notifications.
* The Docker image no longer enables debug mode by default.
* Order glossary terms based on the glossary component priority.
* Added team administrators who can add or remove members of the team.
* Added a popup confirmation before deleting users.
* Added add-on to customize XML output.

[1.10.1]
* Update Weblate to 4.15.1
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.15.1)
* Fixed suggestions from automatic translation.
* Fixed add-on page crash in some corner cases.
* Fixed untranslating template for new translations in some cases.
* Documented licensing using REUSE 3.0.
* Fixed users pagination on team management.

[1.10.2]
* Update Weblate to 4.15.2
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.15.2)
* Enabled gotext JSON and i18next v4 formats in the default
* configuration.
* Fixed crash on uploading corrupted files.
* Show stale directories in Git repository status.

[1.11.0]
* Update Weblate to 4.16.0
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.16.0)
* Format string checks now also detects duplicated formats.
* Improved search performance for some specially formatted strings.
* Celery beat is now storing the tasks schedule in the database.
* Added support for IBM Watson Language Translator.
* Dropped support for VCS integration settings deprecated in 4.14.
* Added support for Bitbucket Server pull requests.
* Improved conflicts handling in gettext PO files.
* Added support for defining strings state when adding via API.
* Added support for configuring CORS allowed origins.
* Added plurals support to automatic suggestions.

[1.11.1]
* Update Weblate to 4.16.1
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.16.1)
* Fixed testsuite error.

[1.11.2]
* Update Weblate to 4.16.2
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.16.2)
* Fixed searching in the translation memory.
* Fixed automatic translation with more services.
* Improved rendering of overlapping glossary term matches.
* Fixed plurals parsing for non-English source language in some
* formats.
* Added support for go-i18n v2 JSON files.

[1.11.3]
* Update Weblate to 4.16.3
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.16.3)
* Improved session handling with project backups.
* Dependencies updates.
* Localization updates.
* Documentation improvements.

[1.11.4]
* Update Weblate to 4.16.4
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.16.4)
* Dependencies updates.
* Improved background tasks scheduling.

[1.12.0]
* Update Weblate to 4.17
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.17)
* Allow to filter on language in reports.
* Dropped deprecated command cleanup_celery.
* Fixed private project visibility for some teams.
* Automatic translation now honors target state when translating from
* other components.
* Improved performance of public user profiles.
* Improved Sentry performance integration.
* Added support for Ed25519 SSH key.
* Rewritten metrics storage.
* Added support for searching strings by position.
* Documentation improvements.
* Unchanged translation check can honor untranslatable terms from
* glossary.
* Added automatic fixup for Devanagari danda.
* Allow downloading project translation memory per language.
* Added new alert on unused components.

[1.13.0]
* Update Weblate to 4.18
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.18)
* Improved API error messages on permission denied.
* Reduced false positives of the XML checks.
* Translated check accuracy has been improved.
* Extended support for Fluent file format.
* Avoiding signing-out user in some rate-limits.
* Added support for storing glossary explanation in TBX format.
* Added support for ordering strings by last update.
* Extended search capabilities for finding users.
* Support for automatic update of screenshots from a repository.
* Improved translation memory performance.
* Project stats exports to JSON/CSV now include more details; it now matches content available in the API.
* Added check for reused translation.
* Highlight suggested change in automatic suggestions.
* Added dark theme; browser-following and manual setting are available.
* Added username autocompletion when adding users to a project.
* Added site-wide search for projects, components, languages and users.
* New add-on Fill read-only strings with source.

[1.13.1]
* Update Weblate to 4.18.1
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.18.1)
* Fixed language code format for i18next.
* Fixed CSS compression with dark theme.

[1.13.2]
* Update Weblate to 4.18.2
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-4.18.2)
* Fixed parsing notes from TBX.
* Fixed query parsing in navigation bar search.
* Fixed language filtering in reports.
* Improved ModernMT languages mapping.
* Disabled reused checks on languages with a single plural form.

[1.14.0]
* Update Weblate to 5.0
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-5.0)

[1.14.1]
* Update Weblate to 5.0.1
* [Full changelog](https://github.com/WeblateOrg/weblate/releases/tag/weblate-5.0.1)
* Added :http:get:/api/component-lists/(str:slug)/components/.
* Related glossary terms lookup is now faster.
* Logging of failures when creating pull requests.
* History is now loaded faster.
* Added object id to all api endpoints.
* Better performance of projects with a lot of components.
* Added compatibility redirects for some old URLs.
* Creating component within a category.
* Source strings and state display for converted formats.
* Block component-edit_template on formats which do not support it.
* check-reused is no longer triggered for blank strings.
* Performace issues while browsing some categories.
* Fixed GitHub Team and Organization authentication in Docker container.
* GitLab merge requests when using a customized SSH port.

