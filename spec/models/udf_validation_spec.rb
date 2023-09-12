require 'spec_helper'

describe UdfValidation do

  before(:each) do
    @s = Object.new.extend(UdfValidation)
  end

  context "is_a_number" do 
    it "should return true if the input is number" do 
      @s.is_a_number?("2").should == true
      @s.is_a_number?("2.70").should == true
    end

    it "should return false if the input is not a number" do 
      @s.is_a_number?("2ab").should == false
      @s.is_a_number?("2.70nb").should == false
      @s.is_a_number?("").should == false
      @s.is_a_number?(nil).should == false
    end
  end

  context "is_a_date" do 
    it "should return true if input is date" do 
      @s.is_a_date?("2014-04-09").should == true
      @s.is_a_date?("2014-02-02").should == true
    end
    it "should return false if input is not a date" do 
      @s.is_a_date?("2").should == false
      @s.is_a_date?("2014-02-2").should == false
      @s.is_a_date?("2014-02-30").should == false
      @s.is_a_date?("2014-02--30").should == false
    end
  end 
  
end