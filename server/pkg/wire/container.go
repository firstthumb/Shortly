// +build wireinject

package wire

import (
	"github.com/google/wire"
	"shortly/pkg/service"
)

var InjectorSet = wire.NewSet(
	service.NewShortenService,
)

func NewContext() service.ShortenService {
	panic(wire.Build(InjectorSet))
}
