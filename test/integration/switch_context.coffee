should = require 'should'
{wd40, browser, base_url, login_url, home_url, prepIntegration} = require './helper'

request = require 'request'

describe 'Context switch', ->
  prepIntegration()

  before (done) ->
    wd40.fill '#username', 'ehg', ->
      wd40.fill '#password', 'testing', -> wd40.click '#login', done

  context 'when I click the context switcher', ->
    before (done) ->
      wd40.click '.context-switch', done

    it 'shows that I can switch into test', (done) ->
      wd40.waitForText "Ickle Test", done

  context 'when I try to access one of Ickle Test’s datasets directly', ->
    before (done) ->
      browser.get "#{base_url}/dataset/3006375730/settings", done

    it 'I see the dataset contents', (done) ->
      browser.waitForElementByCss '#toolbar', 4000, ->
        browser.waitForElementByCss 'iframe', 2000, done

    it 'I have been automatically switched into the Ickle Test’s account', (done) ->
      browser.get home_url, ->
        wd40.elementByPartialLinkText 'Cheese', (err, element) ->
          should.exist element
          wd40.elementByPartialLinkText 'Prune', (err, element) ->
            should.not.exist err
            done()
