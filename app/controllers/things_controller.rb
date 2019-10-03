class ThingsController < ApplicationController

    def index
    end

    def new
    end

    def edit
    end

    def create
        flash[:success] = "A new Thing has been successfully created (but not really)."
        redirect_to root_path
    end

    def delete
        flash[:success] = "The Thing has been successfully deleted (but not really)."
        redirect_to root_path
    end

    def update
        flash[:success] = "The Thing has been successfully updated (but not really)."
        redirect_to show_path
    end

end