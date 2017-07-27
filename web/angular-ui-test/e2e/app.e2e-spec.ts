import { AngularUiTestPage } from './app.po';

describe('angular-ui-test App', () => {
  let page: AngularUiTestPage;

  beforeEach(() => {
    page = new AngularUiTestPage();
  });

  it('should display welcome message', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('Welcome to app!');
  });
});
