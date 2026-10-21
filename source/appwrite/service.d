module appwrite.service;

import appwrite.client;

/// Base class of the API services.
abstract class Service
{
    /// The client requests are sent through.
    protected Client client;

    this(Client client)
    {
        this.client = client;
    }

    /// The client requests are sent through.
    Client getClient()
    {
        return client;
    }
}
