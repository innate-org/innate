class ProfilePolicy < ApplicationPolicy
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end

    def show?
      user == record
    end 

    def update?
      user == record
    end 
end

