require 'test_helper'

class PetTest < ActiveSupport::TestCase

  test "the truth" do
    assert true
  end

  test "Model Required Fields are correct" do
    fields = %w(name age human)
    pet = Pet.new
    fields.each do |field|
      assert_validation pet, field.to_sym, "can't be blank"
    end
  end

  %i(
    name human age
  ).each do |method|
    test_name = "test_user_responds_to_#{method}".to_s
    define_method(test_name) do
      assert Pet.new.respond_to?(method),
        "Pets should respond to #{method}"
    end
  end

  private

  def assert_validation(model, field_name, error_message)
    refute model.valid?
    refute model.save
    assert model.errors.count > 0
    assert model.errors.messages.include?(field_name)
    assert model.errors.messages[field_name].include?(error_message)
  end

end
