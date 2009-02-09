require File.dirname(__FILE__) + '/../spec_helper'
require 'mspec/guards/noncompliance'

describe Object, "#deviates_on" do
  before :all do
    @verbose = $VERBOSE
    $VERBOSE = nil
    @ruby_name = Object.const_get :RUBY_NAME if Object.const_defined? :RUBY_NAME
  end

  after :all do
    $VERBOSE = @verbose
    if @ruby_name
      Object.const_set :RUBY_NAME, @ruby_name
    else
      Object.send :remove_const, :RUBY_NAME
    end
  end

  before :each do
    ScratchPad.clear
  end

  it "raises an Exception when when #standard? returns true" do
    Object.const_set :RUBY_NAME, "ruby"
    lambda {
      deviates_on(:ruby) { ScratchPad.record :yield }
    }.should raise_error(Exception)
    ScratchPad.recorded.should_not == :yield
  end

  it "does not yield when #implementation? returns false" do
    Object.const_set :RUBY_NAME, "jruby"
    deviates_on(:rubinius) { ScratchPad.record :yield }
    ScratchPad.recorded.should_not == :yield
  end

  it "yields when #implementation? returns true" do
    Object.const_set :RUBY_NAME, "jruby"
    deviates_on(:jruby) { ScratchPad.record :yield }
    ScratchPad.recorded.should == :yield
  end
end
