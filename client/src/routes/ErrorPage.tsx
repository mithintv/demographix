import { useRouteError } from "react-router-dom";

type RouterError = {
  statusText: string;
  message: string;
};

export default function ErrorPage() {
  const error: unknown = useRouteError();
  console.error(error);
  const routerError = error as RouterError;

  return (
    <div id="error-page">
      <h1>Oops!</h1>
      <p>Sorry, an unexpected error has occurred.</p>
      <p>
        <i>{routerError.statusText || routerError.message}</i>
      </p>
    </div>
  );
}
