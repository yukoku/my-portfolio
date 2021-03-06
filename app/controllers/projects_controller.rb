class ProjectsController < ApplicationController
  before_action :authenticate_project_member, except: [:index, :new, :create]

  PER = 5

  def index
    if current_user.admin?
      @projects = Project.order(:due_on).page(params[:page]).per(PER)
    else
      @projects = current_user.projects.order(:due_on).page(params[:page]).per(PER)
    end
  end

  def show
    @project_owners = @project.project_members.where(owner: true)
    @search = @project.tickets.order(:due_on).ransack(params[:q])
    @tickets = @search.result.page(params[:page]).per(PER)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      # プロジェクトオーナーは自動的にプロジェクトユーザーに追加する
      current_user.project_members.create!(project_id: @project.id,
                                        accepted_project_invitation: true, owner: true)
      flash[:info] = I18n.t("project.crud.flash.created")
      redirect_to projects_path
    else
      render 'new'
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    if (@project.update_attributes(project_params))
      flash[:success] = I18n.t("project.crud.flash.updated")
      redirect_to @project
    else
      render 'edit'
    end
  end

  def destroy
    Project.find(params[:id]).destroy
    flash[:success] = I18n.t("project.crud.flash.deleted")
    redirect_to projects_path
  end

private

  def project_params
    params.require(:project).permit(:name, :description, :due_on)
  end

  def authenticate_project_member
    @project = Project.find_by(id: params[:id])
    redirect_to projects_path if @project&.users.where(id: current_user.id).empty? && !current_user.admin?
  end
end
