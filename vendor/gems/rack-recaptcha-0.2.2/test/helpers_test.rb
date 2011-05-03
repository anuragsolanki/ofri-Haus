require File.expand_path(File.join(File.dirname(__FILE__),'teststrap'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','rack','recaptcha','helpers'))
require 'riot/rr'

class HelperTest
  attr_accessor :request
  include Rack::Recaptcha::Helpers
  
  def initialize
    @request = HelperTest::Request.new
  end
  
  class Request
    attr_accessor :env
  end
end

context "Rack::Recaptcha::Helpers" do
  setup do
    Rack::Recaptcha.public_key = '0'*40
    @helper = HelperTest.new
  end


  context "recaptcha_tag" do

    context "ajax" do
      context "with display" do
        setup { @helper.recaptcha_tag(:ajax,:display => {:theme => 'red'}) }
        asserts("has js") { topic }.matches %r{recaptcha_ajax.js}
        asserts("has div") { topic }.matches %r{<div id="ajax_recaptcha"></div>}
        asserts("has display") { topic }.matches %r{RecaptchaOptions}
        asserts("has red theme") { topic }.matches %r{"theme":"red"}
      end
      context "without display" do
        setup { @helper.recaptcha_tag(:ajax) }
        asserts("has js") { topic }.matches %r{recaptcha_ajax.js}
        asserts("has div") { topic }.matches %r{<div id="ajax_recaptcha"></div>}
        asserts("has display") { topic =~ %r{RecaptchaOptions} }.not!
        asserts("has red theme") { topic =~ %r{"theme":"red"} }.not!
      end
    end

    context "noscript" do
      setup { @helper.recaptcha_tag :noscript, :public_key => "hello_world_world" }
      asserts("iframe") { topic }.matches %r{iframe}
      asserts("no script tag") { topic }.matches %r{<noscript>}
      asserts("public key") { topic }.matches %r{hello_world_world}
      asserts("has js") { topic =~ %r{recaptcha_ajax.js} }.not!
    end

    context "challenge" do
      setup { @helper.recaptcha_tag(:challenge) }
      asserts("has script tag") { topic }.matches %r{script}
      asserts("has challenge js") { topic }.matches %r{challenge}
      asserts("has js") { topic =~ %r{recaptcha_ajax.js} }.not!
      asserts("has display") { topic =~ %r{RecaptchaOptions} }.not!
      asserts("has public_key") { topic }.matches %r{#{'0'*40}}
    end

    context "server" do
      asserts("using ssl url") { @helper.recaptcha_tag(:challenge, :ssl => true) }.matches %r{https://api-secure.recaptcha.net}
      asserts("using non ssl url") { @helper.recaptcha_tag(:ajax) }.matches %r{http://api.recaptcha.net}
    end

  end

  context "recaptcha_valid?" do
    
    context "passing" do
      setup do
        mock(@helper.request.env).[]('recaptcha.valid').returns(true)
        @helper.recaptcha_valid?
      end
      asserts_topic
    end

    context "failing" do
      setup do
        mock(@helper.request.env).[]('recaptcha.valid').returns(false)
        @helper.recaptcha_valid?
      end
      asserts_topic.not!
    end

  end
end
