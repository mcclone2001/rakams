class ExampleController < ApplicationController
    def index
        render :json => 'hola'
    end
end