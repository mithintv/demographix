import { useState, useRef } from "react";

export default function Search() {
  const [keyword, setKeyword] = useState<string | undefined>(undefined);
  const searchRef = useRef<HTMLInputElement>(null);

  const handleSearch = () => {
    setKeyword(searchRef.current?.value);
  };

  const sendRequest = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    try {
      const response = await fetch(
        `https://moviesdatabase.p.rapidapi.com/titles/search/keyword/${keyword}`,
        {
          method: "GET",
          mode: "cors",
          headers: {
            "content-type": "application/octet-stream",
            "X-RapidAPI-Key": `${import.meta.env.VITE_X_RapidAPI_Key}`,
            "X-RapidAPI-Host": `${import.meta.env.VITE_X_RapidAPI_Host}`,
          },
        }
      );
      const result = await response.text();
      console.log(result);
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <form onSubmit={sendRequest}>
      <label>
        Search
        <input onChange={handleSearch} ref={searchRef} type="text" />
      </label>
      <button type="submit">Search</button>
    </form>
  );
}
