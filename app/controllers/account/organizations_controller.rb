class Account::OrganizationsController < ApplicationController
  respond_to :html, :json
  must_be_authenticated

  def index
    @organizations = current_user.organizations
    respond_with(@organizations)
  end

  def edit
    @organization = current_user.organizations.find(params[:id])
    respond_with(@organization)
  end

  def update
    @organization = current_user.organizations.find(params[:id])

    OrganizationUpdater.new(@organization, organization_params).call
    @organization.save

    respond_with(@organization, location: edit_account_organization_path(@organization))
  end

  def new
    @organization = current_user.organizations.new
    respond_with(@organization)
  end

  def create
    @organization = current_user.organizations.new

    OrganizationUpdater.new(@organization, organization_params).call

    respond_with(
      @organization,
      location: @organization.save && account_organizations_path,
    )
  end

  def leave
    @organization = current_user.organizations.find(params[:id])
    @organization.leave(current_user)

    respond_with(@organization, location: account_organizations_path)
  end

  private

  def organization_params
    params.require(:organization).permit(:name, memberships: [])
  end
end
