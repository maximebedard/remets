class OrganizationsController < ApplicationController
  respond_to :html, :json
  must_be_authenticated

  def index
    @organizations = policy_scope(Organization)
    authorize(@organizations)

    respond_with(@organizations)
  end

  def show
    @organization = policy_scope(Organization.where(id: params[:id])).first!
    authorize(@organization)

    respond_with(@organization)
  end

  def edit
    @organization = policy_scope(Organization.where(id: params[:id])).first!
    authorize(@organization)

    respond_with(@organization)
  end

  def update
    @organization = policy_scope(Organization.where(id: params[:id])).first!
    authorize(@organization)

    @organization.update(organization_params)
    respond_with(@organization, location: account_organization_path(@organization))
  end

  def new
    @organization = policy_scope(Organization).build
    authorize(@organization)

    respond_with(@organization)
  end

  def create
    @organization = policy_scope(Organization).build(organization_params)
    authorize(@organization)

    @organization.save
    respond_with(@organization, location: account_organization_path(@organization))
  end

  private

  def organization_params
    params.require(:organization).permit(:name)
  end
end
