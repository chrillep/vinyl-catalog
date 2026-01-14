import type { NextPage } from 'next'
import Head from 'next/head'
import Link from 'next/link'
import useSWR from 'swr'

const fetcher = (url: RequestInfo) => fetch(url).then((res) => res.json())
const API = 'backend/up'

const Up: NextPage = () => {
  const { data, error } = useSWR(API, fetcher)
  let text = 'Loading...'
  if (error) {
    text = 'Failed to load'
  }
  if (data) {
    text = data.status
  }
  return (
    <div className="w-full h-screen p-0 flex flex-col">
      <Head>
        <title>Vinyl Catalog</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <header className="flex justify-center bg-white py-4 fixed w-full z-10 border-b">
        <h3>Header</h3>
        <Link href="/">Index</Link>
      </header>
      <main className="flex flex-col grow flex-nowrap">
        <div className="flex flex-col min-h-full w-full justify-center items-center container mx-auto py-10">
          <div className="flex flex-col min-h-full items-center justify-center flex-nowrap bg-cool-gray-700">
            <h1 className="text-9xl font-black text-white text-center">
              <span className="bg-gradient-to-r text-transparent bg-clip-text from-green-400 to-purple-500">
                {text}
              </span>
            </h1>
          </div>
        </div>
      </main>
      <footer className="flex w-full items-center justify-center border-t">
        <span className="py-5">Footer</span>
      </footer>
    </div>
  )
}

export default Up
