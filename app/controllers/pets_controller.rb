class PetsController < ApplicationController
  def index
    pets = Pet.all

    render :json => pets.as_json(only: [:id, :human, :age, :name]), status: :ok
  end

  def show
    pet_id = params[:id]

    pet = Pet.find_by(id: pet_id)
    if pet
      render :json => pet.as_json(only: [:id, :human, :age, :name]), status: :ok
    else
      render :json => {ok: false, message: "No Pet with that id"}, status: :no_content
    end
  end

  def update
    pet_id = params[:id]
    pet = Pet.find_by(id: pet_id)
    if pet
      if pet.update(name: params[:name], human: params[:human], age: params[:age])
        render :json => pet.as_json(only: [:id, :human, :age, :name]), status: :ok
      else
        render :json => {ok: false, message: "save failed"}, status: :internal_server_error
      end
    else
      render :json => {ok: false, message: "No Pet with that id"}, status: :no_content
    end

  end

  def destroy
    pet_id = params[:id]
    pet = Pet.find_by(id: pet_id)
    if pet
      if pet.destroy
        render :json => pet.as_json(only: [:id, :human, :age, :name]), status: :ok
      else
        render :json => {ok: false, message: "delete failed"}, status: :internal_server_error
      end
    else
      render :json => {ok: false, message: "No Pet with that id"}, status: :no_content
    end
  end

  def search
    term = params[:query]
    if term
      term = "%#{term}%"
      pets = Pet.where( "name LIKE :search OR human LIKE :search2", search: term, search2: term)

      if pets && pets.length > 0
        render :json => pets.as_json(only: [:id, :human, :age, :name]), status: :ok
      else
        render :json => [], status: :not_found
      end
    else
      redirect index
    end
  end

end
