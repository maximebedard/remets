class OrganizationsController < ApplicationController
  respond_to :html, :json

  def index
    @organizations = policy_scope(Organization.all)
    respond_with(@organizations)
  end

  def show
    @organization = policy_scope(Organization.where(id: params[:id])).first!
    respond_with(@organization)
  end

  def edit
    @organization = policy_scope(Organization.where(id: params[:id])).first!
    respond_with(@organization)
  end

  def update
    @organization = policy_scope(Organization.where(id: params[:id])).first!
    @organization.update(organization_params)
    respond_with(@organization)
  end

  def new
    @organization = Organization.new
    authorize(@organization)

    respond_with(@organization)
  end

  def create
    @organization = Organization.create(organization_params)
    authorize(@organization)

    respond_with(@organization)
  end

  private

  def organization_params
    params.require(:organization).permit(:name)
  end
end
