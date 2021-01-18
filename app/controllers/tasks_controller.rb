class TasksController < ApplicationController
  # TasksController の全アクションをログイン必須にする。
  before_action :require_user_logged_in
  # destroy アクションが実行される前に correct_user が実行される。
  before_action :correct_user, only: [:edit, :update, :destroy]


  def index
    if logged_in?
      @task = current_user.tasks.build  # form_with 用
      @tasks = current_user.tasks.order(id: :desc).page(params[:page]).per(5)
    end
    
  end
  
  def new
      @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
      
    if @task.save
      flash[:success] = 'Taskが正常に投稿されました'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'Taskが投稿されませんでした'
      render 'tasks/index'
    end
  end

  def edit

  end

  def update
    if @task.update(task_params)
      flash[:success] = 'Task が正常に更新されました'
      redirect_to root_url
    else
      flash.now[:danger] = 'Task が更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task.destroy
    flash[:success] = 'Taskを削除しました。'
    redirect_back(fallback_location: root_path)
  
  end
  
  private
  
 
  def task_params
      params.require(:task).permit(:content, :status)
  end
  
  # 本当にログインユーザが所有しているものかを確認する。
  def correct_user
    # ログインユーザ (current_user) が持つ microposts 限定で検索する。
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
    
end
