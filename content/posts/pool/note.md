X-Date: 2024-10-28T12.00.00
Subject: Downloading Uniswap V3 rates with Python
X-Slug: pool

How can you download information about rates from Uniswap v3 using Python?
For example, you may want to use this data for machine learning.
Tools I used:

1. Jupyter
2. GraphQL
3. Zerion (Crypto Wallet)

The first step is to get a key from https://thegraph.com/studio/apikeys/ for future requests. I used the Zerion app and Wallet Connect for authorization. When you enter the site, go to the API Keys tab and click the "Create API Key" button. The Free Plan includes 100,000 free monthly queries.

Now that you have the key, open Jupyter.

Install GraphQL module and import GraphQL client.

```
!pip install python-graphql-client
from python_graphql_client import GraphqlClient
```

On the subgraphs page, you will find Uniswap-V3 (https://thegraph.com/explorer/subgraphs/5zvR82QoaXYFyDEKLZ9t6v9adgnptxYpKpSbxtgVENFV?view=Query&chain=arbitrum-one), and here is a sample endpoint for requests. Note the endpoint in your notebook along with the key.
Next, you have to create an instance of the GraphqlClient, which will be used for GraphQL requests. Pass the endpoint and key as parameters.

```
api_key = "745XXXXXXXXXXXXXXXXX"
query_url = f"https://gateway.thegraph.com/api/{api_key}/subgraphs/id/5zvR82QoaXYFyDEKLZ9t6v9adgnptxYpKpSbxtgVENFV"
client = GraphqlClient(endpoint=query_url)
```

Let's try to write a simple request and get information about a liquidity pool. You can find examples at https://docs.uniswap.org/api/subgraph/guides/examples. Before the request, I want to describe where I found a pool ID. Maybe you know better options, but my approach works too.
On https://app.uniswap.org/swap, we select the Explore -> Pools tab, choose a pool, and find the pool ID at the end of the page link. Don't forget to convert uppercase letters to lowercase. In my case, it is 0x88e6a0c2ddd26feeb64f039a2c41296fcb3f5640 (USDC/ETH).

Request

```
query = """
{
  pools(where: {
    id: "0x88e6a0c2ddd26feeb64f039a2c41296fcb3f5640" 
  }) {
    id
    token0 {
      symbol
    }
    token1 {
      symbol
    }
    feeTier
    liquidity
  }
}
"""

data = client.execute(query=query)
```

Response

```
{'data': {'pools': [{'feeTier': '500',
    'id': '0x88e6a0c2ddd26feeb64f039a2c41296fcb3f5640',
    'liquidity': '9798783347342488587',
    'token0': {'symbol': 'USDC'},
    'token1': {'symbol': 'WETH'}}]}}
```

Now let's see how we can get hourly rates. First, we have to convert the date (start date) to a Unix timestamp.

```
from datetime import datetime
date_str = "2024-10-20T00:00"
timestamp = int(datetime.strptime(date_str, "%Y-%m-%dT%H:%M").timestamp())
print(timestamp)
```

As a result, we get `1729371600`.

Most importantly, we can now request the rate by the hour. We will request the time and price of coins included in the pool.

```
price_query = """
{
  poolHourDatas(
    first: 1000,  
    orderBy: periodStartUnix, 
    where: {
        pool: "0x88e6a0c2ddd26feeb64f039a2c41296fcb3f5640",
        periodStartUnix_gt: """ + str(timestamp) + """
    }
  ) {
    periodStartUnix
    token0Price
    token1Price
  }
}
"""
price_data = client.execute(query=price_query)
```

I will not show the full answer, just a small part, because the response is really large.

```
{'data': {'poolHourDatas': [{'periodStartUnix': 1729375200,
    'token0Price': '2650.084473684463807767240264393468',
    'token1Price': '0.0003773464619449208039677773256294814'},
   {'periodStartUnix': 1729378800,
    'token0Price': '2648.473175353813754428603232436993',
    'token1Price': '0.0003775760348663559356313546234349249'},
   {'periodStartUnix': 1729382400,
    'token0Price': '2643.304803645803843276231192215307',
    'token1Price': '0.0003783142975493179144638745618646462'}]}}
```

Next, we are going to convert our JSON price_data into a regular table.

```
import pandas as pd
price_records = price_data['data']['poolHourDatas']
```

The line `price_records = price_data['data']['poolHourDatas']` performs the following actions:

1. It accesses the key 'data' in the price_data object.
This extracts a nested dictionary that holds information under the 'poolHourDatas' key.
2. Next, it accesses the 'poolHourDatas' key, which contains a list of dictionaries. 
Each dictionary represents a record with a time period and token prices for that period.

After that, we will create a list for the transformed data.

```
formatted_data = []
```

Now we go through all the JSON records and add them to the list (we will transform the date to human-readable format).

```
for record in price_records:
    readable_time = datetime.utcfromtimestamp(record['periodStartUnix']).strftime('%Y-%m-%d %H:%M:%S')
    formatted_data.append({
        'Date & Time': readable_time,
        'Token 0 Price': record['token0Price'],
        'Token 1 Price': record['token1Price']
    })
```

Next, we transform the list into a dataframe and display it.

```
df = pd.DataFrame(formatted_data)
display(df)
```

The end.
