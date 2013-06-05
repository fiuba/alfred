require 'spec_helper'

describe "CoursesController" do
  before do
    get "/"
  end

  it "returns hello world" do
    last_response.status.should eq 200
  end
end
