class ProjectsController < ApplicationController
  def index
    @projects = current_user.projects
  end

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.owner_id = current_user.id
    if @project.save
      # プロジェクトオーナーは自動的にプロジェクトユーザーに追加する
      current_user.project_users.create(project_id: @project.id,
                                        accepted_project_invitation: true)
      flash[:info] = '新しいプロジェクトが作成されました。'
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
      flash[:success] = "プロジェクトを更新しました。"
      redirect_to @project
    else
      render 'edit'
    end
  end

  def destroy
    project_id = params[:id]
    Project.find(params[:id]).destroy
    flash[:success] = "プロジェクトを削除しました。"
    redirect_to projects_path
  end

private

  def project_params
    params.require(:project).permit(:name, :description, :due_on)
  end
end
