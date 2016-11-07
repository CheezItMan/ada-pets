require 'test_helper'

class PetsControllerTest < ActionController::TestCase

  # Necessary setup to allow ensure we support the API JSON type
  setup do
     @request.headers['Accept'] = Mime::JSON
     @request.headers['Content-Type'] = Mime::JSON.to_s
   end

  test "can get #index" do
    get :index
    assert_response :success
  end

  test "Index returns json" do
    get :index
    assert_match 'application/json', response.header['Content-Type']
  end

  test "#index returns json" do
    get :index
    assert_match 'application/json', response.header['Content-Type']
  end

  test "#index returns an Array of Pet objects" do
    get :index
    # Assign the result of the response from the controller action
    body = JSON.parse(response.body)
    assert_instance_of Array, body
  end

  test "returns three pet objects" do
    get :index
    body = JSON.parse(response.body)
    assert_equal 3, body.length
  end

  test "each pet object contains the relevant keys" do
    keys = %w( age human id name )
    get :index
    body = JSON.parse(response.body)
    assert_equal keys, body.map(&:keys).flatten.uniq.sort
  end

  test "Can show one pet" do
    pets = Pet.all

    pets.each do |pet|
      get :show, {id: pet.id}
      body = JSON.parse(response.body)
      assert_instance_of Hash, body
      assert body["name"] == pet.name
      assert body["human"] == pet.human
      assert body["age"] == pet.age
      assert_response :ok
    end
  end

  test "Show hash has the correct keys" do
    pets = Pet.all
    keys = %w( age human id name )

    pets.each do |pet|
      get :show, {id: pet.id}
      body = JSON.parse(response.body)
      assert_equal keys.sort, body.keys.sort
    end
  end
  test "Looking for a pet that doesn't exist fails" do
    get :show, {id: -1}  # can't have a -1 id

    body = JSON.parse(response.body)

    assert_instance_of Hash, body
    assert_response :no_content
  end

  test "Updating a pet changes the field" do

    put :update, {id: pets(:one).id, name: "Kylo", age: 50, human: "Kari"}

    updated_pet = Pet.find_by(id: pets(:one).id)

    assert updated_pet  # the pet exists
    assert updated_pet.name == "Kylo"
    assert updated_pet.age == 50
    assert updated_pet.human == "Kari"
    assert_response :ok
  end
  test "Updating a pet that doesn't exist fails" do
    put :update, {id: -1, name: "Kylo", age: 50, human: "Kari"}
    body = JSON.parse(response.body)
    assert_response :no_content
    assert body[:name] == nil
    assert_not body[:ok]

  end


  test "Can delete one pet" do
    pets = Pet.all

    pets.each do |pet|
      delete :destroy, {id: pet.id}
      body = JSON.parse(response.body)
      assert_instance_of Hash, body
      assert body["name"] == pet.name
      assert body["human"] == pet.human
      assert body["age"] == pet.age
      assert_response :ok
    end
  end

  test "Deleting a pet that doesn't exist fails" do
    delete :destroy, {id: -1}  # can't have a -1 id

    body = JSON.parse(response.body)

    assert_instance_of Hash, body
    assert_response :no_content
  end

end
