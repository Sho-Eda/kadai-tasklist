class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  # TasksController の全アクションをログイン必須にする。
  before_action :require_user_logged_in
  # destroy アクションが実行される前に correct_user が実行される。
  before_action :correct_user, only: [:destroy]


  def index
    if logged_in?
      @task = current_user.tasks.build  # form_with 用
      @tasks = current_user.tasks.order(id: :desc).page(params[:page]).per(5)
    
    end
    
      # @tasks = Task.all.page(params[:page]).per(3)
      
  end

  def show
      set_task
  end

  def new
      @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
      # @task = Task.new(task_params)
      
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
    @task = current_user.tasks.build(task_params)
    # @task = Task.find(params[:id])
  end

  def update
    set_task
    
    if @task.update(task_params)
      flash[:success] = 'Task が正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task が更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task.destroy
    flash[:success] = 'タスクを削除しました。'
    redirect_back(fallback_location: root_path)
    # set_task
    # @task.destroy
    
    # flash[:success] = 'Task は正常に削除されました'
    # redirect_back(fallback_location: root_path)
  end
  
  private
  
  def set_task
    @task = Task.find(params[:id])
  end
  
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
