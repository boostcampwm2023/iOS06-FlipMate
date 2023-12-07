import categoriesData from '../mock-table/categories.json';

export class MockCategoriesRepository {
  private data = categoriesData;
  create(entity: object): object {
    return {
      id: this.data.length + 1,
      ...entity,
    };
  }

  save(entity: object): Promise<object> {
    return Promise.resolve(entity);
  }

  find({ where: { user_id } }): Promise<object> {
    const categories = this.data.filter(
      (category) => category.user_id === user_id.id,
    );
    return Promise.resolve(categories);
  }

  findOne({ where: { id } }): Promise<object> {
    const category = this.data.find((category) => category.id === id);
    if (!category) {
      return Promise.resolve(null);
    }
    const result = {
      ...category,
      user_id: { id: category.user_id },
    };
    return Promise.resolve(result);
  }

  delete(id): Promise<object> {
    const category = this.data.find((category) => category.id === id);
    return Promise.resolve(category);
  }

  count({ where: { user_id } }): Promise<number> {
    const categories = this.data.filter(
      (category) => category.user_id === user_id.id,
    );
    return Promise.resolve(categories.length);
  }
}
