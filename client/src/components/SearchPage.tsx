import {
  Box,
  Button,
  InputAdornment,
  Modal,
  Paper,
  TextField,
  useMediaQuery,
} from "@mui/material";
import { ChangeEvent, useRef, useState } from "react";
import SearchResults from "./SearchResults";

export default function SearchPage({ nav }: { nav: boolean }) {
  const md = useMediaQuery("(max-width:960px)");
  const sm = useMediaQuery("(max-width:600px)");
  // const xs = useMediaQuery("(max-width:425px)");

  const [open, setOpen] = useState(false);
  const searchRef = useRef<HTMLInputElement>(null);
  const [searchInput, setSearchInput] = useState("");

  const handleOpen = () => setOpen(true);
  const handleClose = () => {
    setSearchInput("");
    setOpen(false);
  };

  const searchInputHandler = async () => {
    if (searchRef.current) {
      setSearchInput(searchRef.current.value);
    }
  };

  const searchHandler = async (e: ChangeEvent<HTMLInputElement>) => {
    e.preventDefault();
    if (searchRef.current) {
      const keyword = searchRef.current.value;
      console.log(keyword);

      try {
        const options = {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            search: keyword,
          }),
        };
        const response = await fetch("/api/search", options);
        const json = await response.json();
        console.log(json);
      } catch (err) {
        console.log(err);
      }
    }
  };

  return (
    <>
      <Button
        sx={{ my: 1 }}
        size={sm ? "medium" : "large"}
        startIcon={<span className="material-symbols-outlined">search</span>}
        variant={nav ? "text" : "contained"}
        onClick={handleOpen}
      >
        Search Movies
      </Button>
      {/* {nav && (
        <IconButton
          onClick={handleOpen}
          sx={{ p: "10px" }}
          aria-label="search"
          color="primary"
          variant="outlined"
        >
          <span className="material-symbols-outlined">search</span>
        </IconButton>
      )} */}
      <Modal
        sx={{
          position: "fixed",
        }}
        open={open}
        onClose={handleClose}
        aria-labelledby="search-modal"
        aria-describedby="search modal for movies and other productions"
        slotProps={{
          backdrop: {
            timeout: 500,
          },
        }}
      >
        <Paper
          sx={{
            my: 5,
            mx: "auto",
            width: (sm && "270px") || (md && "460px") || "708px",
            bgcolor: "background.default",
            border: "2px solid #000",
            boxShadow: 24,
            pt: 4,
          }}
        >
          <Box
            onSubmit={searchHandler}
            component="form"
            sx={{
              pt: "0.25rem",
              display: "flex",
              flexDirection: "column",
              justifyContent: "space-between",
              mx: 4,
            }}
          >
            <TextField
              sx={{ width: "100%", mb: 2 }}
              inputRef={searchRef}
              value={searchInput}
              name="search"
              InputProps={{
                startAdornment: (
                  <InputAdornment position="start">
                    <span className="material-symbols-outlined">search</span>
                  </InputAdornment>
                ),
              }}
              placeholder="Search Movies"
              onChange={searchInputHandler}
              variant="standard"
            />
          </Box>
          <SearchResults clicked={open} keywords={searchInput} />
        </Paper>
      </Modal>
    </>
  );
}
