defmodule FuncWrapper.Helper do
  @moduledoc """
  Modules using this module will has a macro: defwrapper.
  When they use defwrapper to def a wrapper, the modules use these wrapper modules
  will change the behaviour of def.
  """

  defmacro __using__(_) do
    quote do
      import FuncWrapper.Helper

      defmacro __using__(_) do
        quote do
          import Kernel, except: [def: 2]
          import unquote(__MODULE__)
        end
      end

      def fun_name_and_args({:when, _, [short_head | _]}) do
        fun_name_and_args(short_head)
      end

      def fun_name_and_args(short_head) do
        Macro.decompose_call(short_head)
      end

      def decorate_args([]), do: {[], []}

      def decorate_args(args_ast) do
        args_ast
        |> Enum.with_index()
        |> Enum.map(&decorate_arg/1)
        |> Enum.unzip()
      end

      defp decorate_arg({arg_ast, index}) do
        if elem(arg_ast, 0) == :\\ do
          {:\\, _, [{optional_name, _, _}, _]} = arg_ast
          {Macro.var(optional_name, nil), arg_ast}
        else
          arg_name = Macro.var(:"arg#{index}", __MODULE__)

          full_arg =
            quote do
              unquote(arg_ast) = unquote(arg_name)
            end

          {arg_name, full_arg}
        end
      end
    end
  end

  defmacro defwrapper(wrap_fun) do
    quote do
      defmacro def(head, expr) do
        wrap_fun = unquote(Macro.escape(wrap_fun))

        quote bind_quoted: [
                head: Macro.escape(head, unquote: true),
                expr: Macro.escape(expr, unquote: true),
                wrap_fun: Macro.escape(wrap_fun)
              ] do
          {fun_name, args_ast} = FuncWrapper.Time.fun_name_and_args(head)
          {arg_names, decorated_args} = FuncWrapper.Time.decorate_args(args_ast)

          wrap_fun =
            wrap_fun ||
              quote do
                fn _, _, _ -> nil end
              end

          head =
            Macro.postwalk(head, fn
              {fun_ast, context, old_args} when fun_ast == fun_name and old_args == args_ast ->
                {fun_ast, context, decorated_args}

              other ->
                other
            end)

          Kernel.def unquote(head) do
            unquote(wrap_fun).(unquote(fun_name), unquote(arg_names), unquote(expr[:do]))
          end
        end
      end
    end
  end
end
