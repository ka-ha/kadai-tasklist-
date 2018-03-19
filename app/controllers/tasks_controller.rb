class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy, :show, :update, :edit]
  
#  before_action :set_task, only: [:show, :edit, :update, :destroy]
  
  def index
    if logged_in?
      @user = current_user
      @task = current_user.tasks.build  # form_for 用
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'メッセージを投稿しました。'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'メッセージの投稿に失敗しました。'
      render 'tasks/index'
    end
  end


#  def create
#    @task = Task.new(task_params)
#    
#    if @task.save
#      flash[:success] = 'Taskが正常に作成されました'
#      redirect_to @task
#    else
#      flash.now[:danger] = 'Taskが作成されませんでした'
#      render :new
#    end
#  end


  def edit
    @task = Task.find(params[:id])
  end

  def update
    
    if @task.update(task_params)
      flash[:success] = 'Taskは正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Taskは更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task.destroy
    
    flash[:success] = 'Taskは正常に削除されました'
    
    redirect_to @task

#    redirect_to tasks_url
#    redirect_back(fallback_location: root_path)
  end
  
  
  private
  
  def set_task
    @task = Task.find(params[:id])
  end
  
  # Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status, :user_id)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
  
end