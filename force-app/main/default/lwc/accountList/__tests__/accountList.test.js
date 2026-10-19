import { createElement } from 'lwc';
import AccountList from 'c/accountList';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';

jest.mock(
    '@salesforce/apex/AccountController.getAccounts',
    () => ({ default: jest.fn() }),
    { virtual: true }
);

const flushPromises = () => new Promise((resolve) => setTimeout(resolve, 0));

function mountComponent() {
    const element = createElement('c-account-list', { is: AccountList });
    document.body.appendChild(element);
    return element;
}

describe('c-account-list', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    it('renders the accounts returned by Apex', async () => {
        getAccounts.mockResolvedValue([
            { Id: '001000000000001AAA', Name: 'Acme' },
            { Id: '001000000000002AAA', Name: 'Globex' }
        ]);

        const element = mountComponent();
        await flushPromises();

        const items = element.shadowRoot.querySelectorAll('li');
        expect(items.length).toBe(2);
        expect(items[0].textContent).toBe('Acme');
    });

    it('shows an empty message when there are no accounts', async () => {
        getAccounts.mockResolvedValue([]);

        const element = mountComponent();
        await flushPromises();

        expect(element.shadowRoot.querySelectorAll('li').length).toBe(0);
        expect(element.shadowRoot.textContent).toContain('No accounts found.');
    });

    it('shows an error message when Apex fails', async () => {
        getAccounts.mockRejectedValue({ body: { message: 'Boom' } });

        const element = mountComponent();
        await flushPromises();

        expect(element.shadowRoot.textContent).toContain('Boom');
    });
});
