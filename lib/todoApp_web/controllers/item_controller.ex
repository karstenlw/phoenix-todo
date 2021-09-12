defmodule TodoAppWeb.ItemController do
  use TodoAppWeb, :controller

  alias TodoApp.Todo
  alias TodoApp.Todo.Item

  # def index(conn, _params) do
  #   items = Todo.list_items()
  #   render(conn, "index.html", items: items)
  # end

  # def index(conn, _params) do
  #   items = Todo.list_items()
  #   changeset = Todo.change_item(%Item{})
  #   render(conn, "index.html", items: items, changeset: changeset)
  # end

  def index(conn, params) do
    item = if not is_nil(params) and Map.has_key?(params, "id") do
      Todo.get_item!(params["id"])
    else
      %Item{}
    end
    items = Todo.list_items()
    changeset = Todo.change_item(item)
    #render(conn, "index.html", items: items, changeset: changeset, editing: item)
    render(conn, "index.html",
      items: items,
      changeset: changeset,
      editing: item,
      filter: Map.get(params, "filter", "all")
    )
  end


  def new(conn, _params) do
    changeset = Todo.change_item(%Item{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"item" => item_params}) do
    case Todo.create_item(item_params) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item created successfully.")
        #|> redirect(to: Routes.item_path(conn, :show, item))
        |> redirect(to: Routes.item_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    item = Todo.get_item!(id)
    render(conn, "show.html", item: item)
  end

  # def edit(conn, %{"id" => id}) do
  #   item = Todo.get_item!(id)
  #   changeset = Todo.change_item(item)
  #   render(conn, "edit.html", item: item, changeset: changeset)
  # end

  def edit(conn, params) do
    index(conn, params)
  end

  # def update(conn, %{"id" => id, "item" => item_params}) do
  #   item = Todo.get_item!(id)

  #   case Todo.update_item(item, item_params) do
  #     {:ok, item} ->
  #       conn
  #       |> put_flash(:info, "Item updated successfully.")
  #       |> redirect(to: Routes.item_path(conn, :show, item))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html", item: item, changeset: changeset)
  #   end
  # end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = Todo.get_item!(id)

    case Todo.update_item(item, item_params) do
      {:ok, _item} ->
        conn
        # |> put_flash(:info, "Item updated successfully.")
        |> redirect(to: Routes.item_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", item: item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Todo.get_item!(id)
    {:ok, _item} = Todo.delete_item(item)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: Routes.item_path(conn, :index))
  end

  def toggle_status(item) do
    case item.status do
      1 -> 0
      0 -> 1
    end
  end

  def toggle(conn, %{"id" => id}) do
    item = Todo.get_item!(id)
    Todo.update_item(item, %{status: toggle_status(item)})
    redirect(conn, to: Routes.item_path(conn, :index))
  end

  import Ecto.Query
  alias TodoApp.Repo

  def clear_completed(conn, _param) do
    person_id = 0
    query = from(i in Item, where: i.person_id == ^person_id, where: i.status == 1)
    Repo.update_all(query, set: [status: 2])
    # render the main template:
    index(conn, %{filter: "all"})
  end

end
