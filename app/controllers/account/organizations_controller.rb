class Account::OrganizationsController < ApplicationController
  respond_to :html, :json
  must_be_authenticated

  def index
    @organizations = policy_scope(Organization)
    authorize(@organizations)

    respond_with(@organizations)
  end

  def edit
    @organization = policy_scope(Organization.where(id: params[:id])).first!
    authorize(@organization)

    respond_with(@organization)
  end

  def update
    @organization = policy_scope(Organization.where(id: params[:id])).first!
    authorize(@organization)

    MembershipsBuilder.new(
      @organization,
      params[:organization][:memberships],
    ).call

    @organization.update(organization_params)
    respond_with(@organization, location: edit_account_organization_path(@organization))
  end

  def new
    @organization = policy_scope(Organization).build
    authorize(@organization)

    respond_with(@organization)
  end

  def create
    @organization = policy_scope(Organization).build(organization_params)
    @organization.user = current_user

    authorize(@organization)

    MembershipsBuilder.new(
      @organization,
      params[:organization][:memberships],
    ).call

    respond_with(
      @organization,
      location: @organization.save &&
        edit_account_organization_path(@organization),
    )
  end

  def leave
    @organization = policy_scope(Organization.where(id: params[:id])).first!
    authorize(@organization)

    @organization.leave(current_user)
    respond_with(@organization, location: account_organizations_path)
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :memberships)
  end
end
