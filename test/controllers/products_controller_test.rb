require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = categories(:test)
    login
  end

  test 'render a list of products' do
    get products_path

    assert_response :success
    assert_select '.product', 5
    assert_select '.category', 10
  end

  test 'render a detailed product page' do
    get product_path(products(:ps4))

    assert_response :success
    assert_select '.title', 'PS4 Fat'
    assert_select '.description', 'PS4 en buen estado'
    assert_select '.price', '$150'
  end

  test 'render a list of products filtred by category' do
    get products_path(category_id: categories(:mobile).id)

    assert_response :success
    assert_select '.product', 2

  end

  test 'render a form for new product' do
    get new_product_path

    assert_response :success
    assert_select 'form'
  end

  test 'allows to create a new product' do
    post products_path, params:{
      product:{
        title: 'Nintendo 64',
        description: 'Le faltan los cables',
        price: 1500,
        category_id: @category.id
      }
    }
    assert_redirected_to products_path
    assert_equal flash[:notice], 'Tu producto se ha creado correctamente'
  end

  test 'does not allow to create a new product with empty fields' do
    post products_path, params:{
      product:{
        title: '',
        description: 'Le faltan los cables',
        price: 1500,
        category_id: @category.id
      }
    }
    assert_response :unprocessable_entity
  end

  test 'render a edit product form' do
    get edit_product_path(products(:ps4))

    assert_response :success
    assert_select 'form'
  end

  test 'allows to update a product' do
    patch product_path(products(:ps4)), params:{
      product:{
        title: 'Nin64',
        description: 'Le faltan los cables',
        price: 150,
        category_id: @category.id
      }
    }
    assert_redirected_to products_path
    assert_equal flash[:notice], 'Tu producto se ha actualizado correctamente'
  end

  test 'does not allows to update a product with empty fields' do
    patch product_path(products(:ps4)), params:{
      product:{
        title: 'Nin64',
        description: 'Le faltan los cables',
        price: nil,
        category_id: @category.id
      }
    }
    assert_response :unprocessable_entity
  end

  test 'can delete product' do
    assert_difference('Product.count',-1) do
      delete product_path(products(:ps4))
    end
    assert_redirected_to products_path
    assert_equal flash[:notice], 'Tu producto se ha eliminado correctamente'
  end
end
